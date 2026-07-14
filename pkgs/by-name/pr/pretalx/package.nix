{
  lib,
  gettext,
  python314,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  plugins ? [ ],
  nixosTests,
}:

let
  python = python314.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_6;
    };
  };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pretalx";
  version = "2026.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dsnnr9/G8i5vfcinRiqpGv1ce90LwW7Esj/SrTK1Ov4=";
  };

  npmRoot = "src/pretalx/frontend";
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/src/pretalx/frontend";
    hash = "sha256-wWGNvUT9SFIm/Gfl8wuOe9xTn1QqH6JWoOIHTiSg0rQ=";
  };

  outputs = [
    "out"
    "static"
  ];

  postPatch = ''
    # we already provide npm deps
    sed -i "/npm.*ci/d" src/pretalx/_build.py
  '';

  nativeBuildInputs = [
    gettext
    npmHooks.npmConfigHook
    nodejs
  ];

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "beautifulsoup4"
    "bleach"
    "celery"
    "css_inline"
    "cssutils"
    "defusedcsv"
    "defusedxml"
    "django-csp"
    "django-filter"
    "django-formset-js-improved"
    "django-formtools"
    "django-i18nfield"
    "djangorestframework"
    "markdown"
    "pillow"
    "publicsuffixlist"
    "python-dateutil"
    "reportlab"
    "requests"
    "rules"
    "whitenoise"
  ];

  dependencies =
    with python.pkgs;
    [
      beautifulsoup4
      bleach
      celery
      css-inline
      cssutils
      defusedcsv
      defusedxml
      diff-match-patch
      django
      django-context-decorator
      django-csp
      django-filter
      django-formtools
      django-hierarkey
      django-i18nfield
      django-minify-html
      django-scopes
      django-tables2
      djangorestframework
      drf-flex-fields
      drf-spectacular
      markdown
      pillow
      publicsuffixlist
      python-dateutil
      qrcode
      redis
      reportlab
      requests
      rules
      urlman
      vobject
      whitenoise
      zxcvbn
    ]
    ++ beautifulsoup4.optional-dependencies.lxml
    ++ django.optional-dependencies.argon2
    ++ whitenoise.optional-dependencies.brotli
    ++ plugins;

  optional-dependencies = {
    postgres = with python.pkgs; [
      psycopg2
    ];
  };
  postBuild = ''
    # Generate all static files and translations, see
    # https://docs.pretalx.org/administrator/commands.html#python-m-pretalx-rebuild
    PYTHONPATH=$PYTHONPATH:./src python -m pretalx rebuild
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ./src/manage.py $out/bin/pretalx-manage

    # Copy and merge static files
    mkdir -p $static
    cp -r ./src/static.dist/** $static/

    # And link them into the package for staticfiles lookups
    rm -rf $out/${python.sitePackages}/pretalx/static
    ln -s $static/ $out/${python.sitePackages}/pretalx/static
  '';

  preCheck = ''
    export PRETALX_CONFIG_FILE="$src/src/tests/ci_sqlite.cfg"
  '';

  nativeCheckInputs =
    with python.pkgs;
    [
      faker
      factory-boy
      freezegun
      jsonschema
      polib
      pytest-cov-stub
      pytest-django
      pytest-mock
      pytest-xdist
      pytestCheckHook
      responses
    ]
    ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    #  assert 'tests.dummy_app' in ['pretalx_pages']
    "test_event_wizard_plugin_form_init_creates_field_for_installed_plugins"
  ];

  passthru = {
    inherit python;
    tests = {
      inherit (nixosTests) pretalx;
    };
    plugins = lib.recurseIntoAttrs (
      lib.packagesFromDirectoryRecursive {
        inherit (python.pkgs) callPackage;
        directory = ./plugins;
      }
    );
  };

  meta = {
    description = "Conference planning tool: CfP, scheduling, speaker management";
    mainProgram = "pretalx-manage";
    homepage = "https://github.com/pretalx/pretalx";
    changelog = "https://docs.pretalx.org/changelog/v${finalAttrs.version}/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hexa
      SuperSandro2000
    ];
    platforms = lib.platforms.linux;
  };
})
