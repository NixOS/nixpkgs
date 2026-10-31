{
  lib,
  callPackage,
  fetchFromGitHub,
  python3,
  nodejs_22,
  makeWrapper,
  gettext,
  nixosTests,
  seafile-server,
}:
let
  py = python3.pkgs;

  # Seahub imports the SAML stack unconditionally at startup
  # (see seahub/auth/views.py), so pysaml2
  # must be present for the server to run at all. pysaml2 only supports
  # xmlschema <3.0.0 while nixpkgs ships 4.x.
  # See https://github.com/IdentityPython/pysaml2/issues/947
  elementpathCompat = py.elementpath.overridePythonAttrs (_: rec {
    version = "4.7.0";
    src = fetchFromGitHub {
      owner = "sissaschool";
      repo = "elementpath";
      tag = "v${version}";
      hash = "sha256-vGIcJuY/RHmfsEngr1XRkA2Lls9hUl/6XTbUJVz5Ndk=";
    };
  });
  xmlschemaCompat = py.xmlschema.overridePythonAttrs (old: rec {
    version = "2.5.1";
    src = fetchFromGitHub {
      owner = "sissaschool";
      repo = "xmlschema";
      tag = "v${version}";
      hash = "sha256-qUc67KdCcnPZszgUiET9T8vpmI1QoM95vzLPAU+4lnI=";
    };
    dependencies = [ elementpathCompat ];
    # Python 3.14 adds pathlib deprecation warnings that these tests count as
    # part of their output. The suite passes on Python 3.13; omit only the two
    # tests whose warning counts change under 3.14.
    disabledTests = (old.disabledTests or [ ]) ++ [
      "test_schema_resource_access"
      "test_wrong_includes_and_imports"
    ];
  });
  pysaml2Compat = py.pysaml2.override { xmlschema = xmlschemaCompat; };
  djangosaml2Compat =
    (py.djangosaml2.override { pysaml2 = pysaml2Compat; }).overridePythonAttrs
      (_: rec {
        version = "1.11.1";
        src = fetchFromGitHub {
          owner = "IdentityPython";
          repo = "djangosaml2";
          # The v1.11.1-1 tag's setup.py still declares 1.11.1.
          tag = "v${version}-1";
          hash = "sha256-f7VgysfGpwt4opmXXaigRsOBS506XB/jZV1zRiYwZig=";
        };
      });
in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "seahub";
  version = "13.0.28";

  src = fetchFromGitHub {
    name = "seahub-source";
    owner = "haiwen";
    repo = "seahub";

    # Using a fixed revision because upstream may re-tag releases.
    rev = "b5b44cae9c504df59f1e0a92a1991bed4fa6f89b";
    hash = "sha256-TXkOwMVG1jNawpQ2B+x1VEzONNwpGELRYQ7zwlpN/j4=";
  };

  pyproject = false;
  __structuredAttrs = true;
  strictDeps = true;

  doCheck = false; # requires a running seafile environment in 188 tests (essentially all)

  nativeBuildInputs = [
    makeWrapper
    gettext
  ];

  propagatedBuildInputs = with python3.pkgs; [
    django
    django-statici18n
    django-webpack-loader
    django-picklefield
    django-formtools
    django-simple-captcha
    captcha
    djangorestframework
    mysqlclient
    pillow
    pillow-heif
    python-dateutil
    requests
    requests-oauthlib
    chardet
    pyjwt
    pycryptodome
    pyopenssl
    python-ldap
    qrcode
    pysearpc
    gunicorn
    markdown
    bleach
    openpyxl
    cffi
    redis
    pylibmc
    cairosvg
    pypinyin
    dnspython
    python-cas
    djangosaml2Compat
    pysaml2Compat
    (python3.pkgs.toPythonModule (seafile-server.override { inherit python3; }))
  ];

  postPatch = ''
    substituteInPlace seahub/settings.py \
      --replace-fail "SEAFILE_VERSION = '6.3.3'" "SEAFILE_VERSION = '${finalAttrs.version}'"

    # Upstream's memcached cache backend is the unmaintained third-party
    # django_pylibmc; Django 5.2 ships an equivalent built-in PyLibMCCache.
    # That is NOT dead.
    substituteInPlace seahub/settings.py \
      --replace-fail "django_pylibmc.memcached.PyLibMCCache" \
        "django.core.cache.backends.memcached.PyLibMCCache"
  '';

  env.DJANGO_SETTINGS_MODULE = "seahub.settings";
  buildPhase = ''
    runHook preBuild

    # Thirdpart is vendored in-tree, so grab it into env
    export PYTHONPATH="$PWD/thirdpart:$PYTHONPATH"

    # Importing seaserv needs these paths even for management commands that
    # only compile translations and collect static assets.
    export SEAFILE_DATA_DIR="$NIX_BUILD_TOP/seafile-data"
    export SEAFILE_CENTRAL_CONF_DIR="$NIX_BUILD_TOP/seafile-conf"
    mkdir -p "$SEAFILE_DATA_DIR" "$SEAFILE_CENTRAL_CONF_DIR"

    # No live seafile/ccnet server or database is needed for any of these:
    # they only touch translation catalogs and static assets.
    python3 manage.py compilemessages
    python3 manage.py compilejsi18n
    python3 manage.py collectstatic --noinput -i admin -i termsandconditions

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -dr --no-preserve='ownership' . $out/

    # Embed the webpack-built SPA. django-webpack-loader reads
    # frontend/webpack-stats.pro.json (WEBPACK_LOADER.STATS_FILE) to map bundle
    # names to the hashed files under frontend/build/ (a STATICFILES_DIRS entry).
    mkdir -p $out/frontend/build
    cp -r ${finalAttrs.passthru.seahub-frontend}/frontend $out/frontend/build/frontend
    cp ${finalAttrs.passthru.seahub-frontend}/webpack-stats.pro.json $out/frontend/webpack-stats.pro.json

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/manage.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:"
  '';

  passthru = {
    inherit python3 seafile-server;

    seahub-frontend = callPackage ./seahub-frontend.nix {
      inherit (finalAttrs) version src;
      nodejs = nodejs_22;
    };

    pythonPath = python3.pkgs.makePythonPath finalAttrs.propagatedBuildInputs;
    tests = {
      inherit (nixosTests) seafile;
    };
  };

  meta = {
    description = "Web frontend for the Seafile file sync and share server";
    homepage = "https://github.com/haiwen/seahub";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.linux;
  };
})
