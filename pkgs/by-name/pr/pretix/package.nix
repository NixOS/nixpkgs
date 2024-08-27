{ lib
, buildNpmPackage
, fetchFromGitHub
, fetchPypi
, fetchpatch2
, nodejs
, python3
, gettext
, nixosTests
, plugins ? [ ]
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_4;

      stripe = super.stripe.overridePythonAttrs rec {
        version = "7.9.0";

        src = fetchPypi {
          pname = "stripe";
          inherit version;
          hash = "sha256-hOXkMINaSwzU/SpXzjhTJp0ds0OREc2mtu11LjSc9KE=";
        };
      };

      pretix-plugin-build = self.callPackage ./plugin-build.nix { };
    };
  };

  pname = "pretix";
  version = "2024.4.0";

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix";
    rev = "refs/tags/v${version}";
    hash = "sha256-+F5EOMMkO1ngGeFscDipwbldsY0AhOUKbjqgNpuph4g=";
  };

  npmDeps = buildNpmPackage {
    pname = "pretix-node-modules";
    inherit version src;

    sourceRoot = "${src.name}/src/pretix/static/npm_dir";
    npmDepsHash = "sha256-0Q/BCRHlnyQJlCF3PgIP9q3Qyr/ff+GP0lPIwPsIMSU=";

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

    (fetchpatch2 {
      name = "CVE-2024-8113.patch";
      url = "https://github.com/pretix/pretix/commit/0f44a2ad4e170882dbe6b9d95dba6c36e4e181cf.patch";
      hash = "sha256-N5Fvf7tfZvtqDy7fO7sPBhtew8uGFLzK+kVO/hMgEIY=";
    })
  ];

  postPatch = ''
    NODE_PREFIX=src/pretix/static.dist/node_prefix
    mkdir -p $NODE_PREFIX
    cp -R ${npmDeps}/node_modules $NODE_PREFIX/
    chmod -R u+w $NODE_PREFIX/

    # unused
    sed -i "/setuptools-rust/d" pyproject.toml

    substituteInPlace pyproject.toml \
      --replace-fail phonenumberslite phonenumbers \
      --replace-fail psycopg2-binary psycopg2 \
      --replace-fail vat_moss_forked==2020.3.20.0.11.0 vat-moss \
      --replace-fail "bleach==5.0.*" bleach \
      --replace-fail "django-hierarkey==1.1.*" django-hierarkey \
      --replace-fail "djangorestframework==3.15.*" djangorestframework \
      --replace-fail "dnspython==2.6.*" dnspython \
      --replace-fail "importlib_metadata==7.*" importlib_metadata \
      --replace-fail "markdown==3.6" markdown \
      --replace-fail "protobuf==5.26.*" protobuf \
      --replace-fail "pycryptodome==3.20.*" pycryptodome \
      --replace-fail "pypdf==3.9.*" pypdf \
      --replace-fail "python-dateutil==2.9.*" python-dateutil \
      --replace-fail "stripe==7.9.*" stripe
  '';

  build-system = with python.pkgs; [
    gettext
    nodejs
    setuptools
    tomli
  ];

  dependencies = with python.pkgs; [
    arabic-reshaper
    babel
    beautifulsoup4
    bleach
    celery
    chardet
    cryptography
    css-inline
    defusedcsv
    dj-static
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
    phonenumbers
    pillow
    pretix-plugin-build
    protobuf
    psycopg2
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
    slimit
    static3
    stripe
    text-unidecode
    tlds
    tqdm
    ua-parser
    vat-moss
    vobject
    webauthn
    zeep
  ] ++ plugins;

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

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
    pytest-xdist
    pytest-mock
    pytest-django
    pytest-asyncio
    pytest-rerunfailures
    freezegun
    fakeredis
    responses
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [
    "--reruns" "3"
  ];

  disabledTests = [
    # unreliable around day changes
    "test_order_create_invoice"
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
    plugins = lib.recurseIntoAttrs
      (python.pkgs.callPackage ./plugins {
        inherit (python.pkgs) callPackage;
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
