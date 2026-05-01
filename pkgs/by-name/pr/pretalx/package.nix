{
  lib,
  buildNpmPackage,
  gettext,
  python314,
  fetchFromGitHub,
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

  version = "2026.1.2";

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx";
    tag = "v${version}";
    hash = "sha256-/hs2sPeHyv06aXfUn7UdaGJo9UQ2hah/nufSxG+wO5Q=";
  };

  meta = {
    description = "Conference planning tool: CfP, scheduling, speaker management";
    mainProgram = "pretalx-manage";
    homepage = "https://github.com/pretalx/pretalx";
    changelog = "https://docs.pretalx.org/changelog/v${version}/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hexa
      SuperSandro2000
    ];
    platforms = lib.platforms.linux;
  };

  pretix-schedule-editor = buildNpmPackage {
    pname = "pretalx-schedule-editor";
    inherit version src;

    sourceRoot = "${src.name}/src/pretalx/frontend/schedule-editor";

    npmDepsHash = "sha256-66PA2COL3lqMspYGoF/bOJje5URRu1voQbZspM7DTxs=";

    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp dist/** $out/

      runHook postInstall
    '';

    inherit meta;
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "pretalx";
  inherit version src;
  pyproject = true;

  outputs = [
    "out"
    "static"
  ];

  patches = [
    # don't run npm during rebuild command, we already use a separate derivation
    # to build static assets
    ./rebuild-no-npm.patch
  ];

  nativeBuildInputs = [
    gettext
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
    redis = with python.pkgs; [
      redis
    ];
  };

  postBuild = ''
    # link schedule-editor so it can be picked up in staticfiles lookups
    ln -s ${pretix-schedule-editor}/** ./src/pretalx/static/

    # Generate all static files, see https://docs.pretalx.org/administrator/commands.html#python-m-pretalx-rebuild
    PYTHONPATH=$PYTHONPATH:./src python -m pretalx rebuild
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ./src/manage.py $out/bin/pretalx-manage

    # Copy and merge static files
    mkdir -p $static
    cp -r ./src/static.dist/** $static/
    cp -r ${pretix-schedule-editor}/** $static/

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
    ++ lib.concatAttrValues optional-dependencies;

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

  inherit meta;
}
