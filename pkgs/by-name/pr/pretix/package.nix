{
  lib,
  fetchFromGitHub,
  fetchPypi,
  fetchNpmDeps,
  libredirect,
  nodejs,
  npmHooks,
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
      django = super.django_5;

      django-oauth-toolkit = super.django-oauth-toolkit.overridePythonAttrs (oldAttrs: rec {
        version = "2.3.0";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          tag = "v${version}";
          hash = "sha256-oGg5MD9p4PSUVkt5pGLwjAF4SHHf4Aqr+/3FsuFaybY=";
        };
        disabledTests = [
          # error message mismatch
          "test_validation_failed_message"
          # fails dns resolution
          "test_response_when_auth_server_response_return_404"
        ];
      });

      stripe = super.stripe.overridePythonAttrs rec {
        version = "7.9.0";

        src = fetchPypi {
          pname = "stripe";
          inherit version;
          hash = "sha256-hOXkMINaSwzU/SpXzjhTJp0ds0OREc2mtu11LjSc9KE=";
        };

        build-system = with self; [ setuptools ];
      };

      pretix = self.toPythonModule pretix;
      pretix-plugin-build = self.callPackage ./plugin-build.nix { };
    };
  };
  pythonPackages = python.pkgs;
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "pretix";
  version = "2026.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yKJGJziMpOB8ttz0n4USay03wJTId77bYT7id4OgoIE=";
  };

  patches = [
    # Discover pretix.plugin entrypoints during build and add them into
    # INSTALLED_APPS, so that their static files are collected.
    ./plugin-build.patch
  ];

  postPatch = ''
    # unused
    sed -i "/setuptools-rust/d" pyproject.toml

    # unbreak dependency relaxation
    substituteInPlace pyproject.toml \
      --replace-fail '"backend"' '"setuptools.build_meta"' \
      --replace-fail 'backend-path = ["_build"]' ""

    # we take care of the npm build
    substituteInPlace src/pretix/_build.py \
      --replace-fail "npm ci" "true" \
      --replace-fail "npm run build" "true"
  '';

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-DJCvNcgDIY71Q9qg4Ng7SAM9i9wHhHOdJonpt5t/Xx8=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  preBuild = ''
    npm run build
  '';

  build-system = with pythonPackages; [
    gettext
    nodejs
    setuptools
    tomli
  ];

  dependencies =
    with pythonPackages;
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

  optional-dependencies = with pythonPackages; {
    memcached = [
      pylibmc
    ];
  };

  pythonRelaxDeps = [
    "beautifulsoup4"
    "bleach"
    "celery"
    "css-inline"
    "cryptography"
    "django-bootstrap3"
    "django-compressor"
    "django-filter"
    "django-formset-js-improved"
    "django-i18nfield"
    "django-localflavor"
    "django-phonenumber-field"
    "dnspython"
    "drf_ujson2"
    "importlib_metadata"
    "kombu"
    "markdown"
    "oauthlib"
    "phonenumberslite"
    "pillow"
    "protobuf"
    "pycparser"
    "pycryptodome"
    "pyjwt"
    "pypdf"
    "python-bidi"
    "qrcode"
    "redis"
    "reportlab"
    "requests"
    "sentry-sdk"
    "sepaxml"
    "ua-parser"
    "webauthn"
  ];

  pythonRemoveDeps = [
    "vat_moss_forked" # we provide a patched vat-moss package
  ];

  postInstall = ''
    mkdir -p $out/bin
    cp ./src/manage.py $out/${python.sitePackages}/pretix/manage.py
    makeWrapper $out/${python.sitePackages}/pretix/manage.py $out/bin/pretix-manage \
      --prefix PYTHONPATH : "$PYTHONPATH"

    # Trim packages size
    rm -rfv $out/${python.sitePackages}/pretix/static.dist/node_prefix
  '';

  dontStrip = true; # no binaries

  nativeCheckInputs =
    with pythonPackages;
    [
      libredirect.hook
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
    ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [
    "--reruns=3"
  ];

  disabledTests = [
    # unreliable around day changes
    "test_order_create_invoice"
  ];

  disabledTestPaths = [
    # too expensive
    "src/tests/e2e"
  ];

  preCheck = ''
    export PYTHONPATH=$(pwd)/src:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE=tests.settings

    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/resolv.conf=$(realpath resolv.conf)
  '';

  postCheck = ''
    unset NIX_REDIRECTS
  '';

  passthru = {
    inherit
      python
      ;
    plugins = lib.recurseIntoAttrs (
      lib.packagesFromDirectoryRecursive {
        inherit (pythonPackages) callPackage;
        directory = ./plugins;
      }
    );
    tests = {
      inherit (nixosTests) pretix;
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "Ticketing software that cares about your event—all the way";
    homepage = "https://github.com/pretix/pretix";
    license = with lib.licenses; [
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
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "pretix-manage";
    platforms = lib.platforms.linux;
  };
})
