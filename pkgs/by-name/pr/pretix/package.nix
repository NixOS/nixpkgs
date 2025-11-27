{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchPypi,
  nodejs,
  python3,
  gettext,
  nixosTests,
  pretix,
  plugins ? [ ],
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      django = super.django_4;

      django-oauth-toolkit = super.django-oauth-toolkit.overridePythonAttrs (oldAttrs: {
        version = "2.3.0";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          rev = "refs/tags/v${version}";
          hash = "sha256-oGg5MD9p4PSUVkt5pGLwjAF4SHHf4Aqr+/3FsuFaybY=";
        };
      });

      stripe = super.stripe.overridePythonAttrs rec {
        version = "7.9.0";

        src = fetchPypi {
          pname = "stripe";
          inherit version;
          hash = "sha256-hOXkMINaSwzU/SpXzjhTJp0ds0OREc2mtu11LjSc9KE=";
        };
      };

      pretix = self.toPythonModule pretix;
      pretix-plugin-build = self.callPackage ./plugin-build.nix { };
    };
  };

  pname = "pretix";
  version = "2025.4.0";

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix";
    rev = "refs/tags/v${version}";
    hash = "sha256-K/llv85CWp+V70BiYAR7lT+urGdLbXBhWpCptxUqDrc=";
  };

  npmDeps = buildNpmPackage {
    pname = "pretix-node-modules";
    inherit version src;

    sourceRoot = "${src.name}/src/pretix/static/npm_dir";
    npmDepsHash = "sha256-FqwgHmIUfcipVbeXmN4uYPHdmnuaSgOQ9LHgKRf16ys=";

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -R node_modules $out/

      runHook postInstall
    '';
  };
in
python.pkgs.buildPythonApplication rec {
  inherit pname version src;
  pyproject = true;

  patches = [
    # Discover pretix.plugin entrypoints during build and add them into
    # INSTALLED_APPS, so that their static files are collected.
    ./plugin-build.patch

    # https://pretix.eu/about/en/blog/20251127-release-2025-9-2/
    ./CVE-2025-13742.patch
  ];

  pythonRelaxDeps = [
    "beautifulsoup4"
    "celery"
    "django-bootstrap3"
    "django-phonenumber-field"
    "dnspython"
    "drf_ujson2"
    "importlib-metadata"
    "kombu"
    "markdown"
    "phonenumberslite"
    "pillow"
    "protobuf"
    "pycryptodome"
    "pyjwt"
    "pypdf"
    "python-bidi"
    "qrcode"
    "redis"
    "reportlab"
    "requests"
    "sentry-sdk"
    "ua-parser"
    "webauthn"
  ];

  pythonRemoveDeps = [
    "vat_moss_forked" # we provide a patched vat-moss package
  ];

  postPatch = ''
    NODE_PREFIX=src/pretix/static.dist/node_prefix
    mkdir -p $NODE_PREFIX
    cp -R ${npmDeps}/node_modules $NODE_PREFIX/
    chmod -R u+w $NODE_PREFIX/

    # unused
    sed -i "/setuptools-rust/d" pyproject.toml

    substituteInPlace pyproject.toml \
      --replace-fail '"backend"' '"setuptools.build_meta"' \
      --replace-fail 'backend-path = ["_build"]' ""
  '';

  build-system = with python.pkgs; [
    gettext
    nodejs
    setuptools
    tomli
  ];

  dependencies =
    with python.pkgs;
    [
      arabic-reshaper
      babel
      beautifulsoup4
      bleach
      celery
      chardet
      cryptography
      css-inline
      defusedcsv
      django
      django-bootstrap3
      django-compressor
      django-countries
      django-filter
      django-formset-js-improved
      django-formtools
      django-hierarkey
      django-hijack
      django-i18nfield
      django-libsass
      django-localflavor
      django-markup
      django-oauth-toolkit
      django-otp
      django-phonenumber-field
      django-redis
      django-scopes
      django-statici18n
      djangorestframework
      dnspython
      drf-ujson2
      geoip2
      importlib-metadata
      isoweek
      jsonschema
      kombu
      libsass
      lxml
      markdown
      mt-940
      oauthlib
      openpyxl
      packaging
      paypalrestsdk
      paypal-checkout-serversdk
      pyjwt
      phonenumberslite
      pillow
      pretix-plugin-build
      protobuf
      psycopg2-binary
      pycountry
      pycparser
      pycryptodome
      pypdf
      python-bidi
      python-dateutil
      pytz
      pytz-deprecation-shim
      pyuca
      qrcode
      redis
      reportlab
      requests
      sentry-sdk
      sepaxml
      stripe
      text-unidecode
      tlds
      tqdm
      ua-parser
      vat-moss
      vobject
      webauthn
      zeep
    ]
    ++ django.optional-dependencies.argon2
    ++ plugins;

  optional-dependencies = with python.pkgs; {
    memcached = [
      pylibmc
    ];
  };

  postInstall = ''
    mkdir -p $out/bin
    cp ./src/manage.py $out/bin/pretix-manage

    # Trim packages size
    rm -rfv $out/${python.sitePackages}/pretix/static.dist/node_prefix
  '';

  dontStrip = true; # no binaries

  nativeCheckInputs =
    with python.pkgs;
    [
      pytestCheckHook
      pytest-xdist
      pytest-mock
      pytest-django
      pytest-asyncio
      pytest-rerunfailures
      freezegun
      fakeredis
      responses
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [
    "--reruns"
    "3"
  ];

  disabledTests = [
    # unreliable around day changes
    "test_order_create_invoice"

    # outdated translation files
    # https://github.com/pretix/pretix/commit/c4db2a48b6ac81763fa67475d8182aee41c31376
    "test_different_dates_spanish"
    "test_same_day_spanish"
    "test_same_month_spanish"
    "test_same_year_spanish"
  ];

  preCheck = ''
    export PYTHONPATH=$(pwd)/src:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  passthru = {
    inherit
      npmDeps
      python
      ;
    plugins = lib.recurseIntoAttrs (
      lib.packagesFromDirectoryRecursive {
        inherit (python.pkgs) callPackage;
        directory = ./plugins;
      }
    );
    tests = {
      inherit (nixosTests) pretix;
    };
  };

  meta = with lib; {
    description = "Ticketing software that cares about your event—all the way";
    homepage = "https://github.com/pretix/pretix";
    license = with licenses; [
      agpl3Only
      # 3rd party components below src/pretix/static
      bsd2
      isc
      mit
      ofl # fontawesome
      unlicense
      # all other files below src/pretix/static and src/pretix/locale and aux scripts
      asl20
    ];
    maintainers = with maintainers; [ hexa ];
    mainProgram = "pretix-manage";
    platforms = platforms.linux;
  };
}
