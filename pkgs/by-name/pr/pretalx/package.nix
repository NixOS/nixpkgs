{
  lib,
  buildNpmPackage,
  gettext,
  python3,
  fetchFromGitHub,
  plugins ? [ ],
  nixosTests,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_5_2;

      django-countries = prev.django-countries.overridePythonAttrs (oldAttrs: rec {
        version = "8.1.0";
        src = fetchFromGitHub {
          owner = "SmileyChris";
          repo = "django-countries";
          tag = "v${version}";
          hash = "sha256-KtBFSkYNKwivCFlqlWm4idiMybqsqiV0SNZx3egLl6c=";
        };
        build-system = with final; [ uv-build ];
      });

      django-tables2 = prev.django-tables2.overridePythonAttrs (oldAttrs: rec {
        version = "2.7.0";
        src = fetchFromGitHub {
          owner = "jieter";
          repo = "django-tables2";
          tag = "v${version}";
          hash = "sha256-Cb8XhCLqhc2Dx/5uAHnN9zTVL6/1+WekC4qTloBurzM=";
        };
      });
    };
  };

  version = "2025.2.0";

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx";
    tag = "v${version}";
    hash = "sha256-em5bPKKlT3qUAv4zGGjOkjDPY7U8vbuqMZ8NQXwZg4k=";
  };

  meta = {
    description = "Conference planning tool: CfP, scheduling, speaker management";
    mainProgram = "pretalx-manage";
    homepage = "https://github.com/pretalx/pretalx";
    changelog = "https://docs.pretalx.org/changelog/#${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
    teams = [ lib.teams.c3d2 ];
    platforms = lib.platforms.linux;
  };

  pretix-schedule-editor = buildNpmPackage {
    pname = "pretalx-schedule-editorc";
    inherit version src;

    sourceRoot = "${src.name}/src/pretalx/frontend/schedule-editor";

    npmDepsHash = "sha256-voHiml0nFWZIST39D5ErB0xTiWAOHN9OZinYutuQcdg=";

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
      django-countries
      django-csp
      django-filter
      django-formset-js-improved
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
    cd src
  '';

  nativeCheckInputs =
    with python.pkgs;
    [
      faker
      freezegun
      jsonschema
      pytest-cov-stub
      pytest-django
      pytest-mock
      pytest-xdist
      pytestCheckHook
      responses
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # tries to run npm run i18n:extract
    "test_common_custom_makemessages_does_not_blow_up"
    # Expected to perform X queries or less but Y were done
    "test_can_see_schedule"
    "test_schedule_export_public"
    "test_schedule_frab_json_export"
    "test_schedule_frab_xcal_export"
    "test_schedule_frab_xml_export"
    "test_schedule_frab_xml_export_control_char"
    "test_schedule_page_text_list"
    "test_schedule_page_text_table"
    "test_schedule_page_text_wrong_format"
    "test_versioned_schedule_page"
    # Test is racy
    "test_can_reset_password_by_email"
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
