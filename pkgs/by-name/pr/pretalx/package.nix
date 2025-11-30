{
  lib,
  buildNpmPackage,
  gettext,
  python3,
  fetchFromGitHub,
  fetchPypi,
  plugins ? [ ],
  nixosTests,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_5_1;

      django-csp = prev.django-csp.overridePythonAttrs rec {
        version = "3.8";
        src = fetchPypi {
          inherit version;
          pname = "django_csp";
          hash = "sha256-7w8an32Nporm4WnALprGYcDs8E23Dg0dhWQFEqaEccA=";
        };
      };

      django-extensions = prev.django-extensions.overridePythonAttrs {
        # Compat issues with Django 5.1
        # https://github.com/django-extensions/django-extensions/issues/1885
        doCheck = false;
      };

      django-hierarkey = prev.django-hierarkey.overridePythonAttrs rec {
        version = "1.2.1";
        src = fetchFromGitHub {
          owner = "raphaelm";
          repo = "django-hierarkey";
          tag = version;
          hash = "sha256-GkCNVovo2bDCp6m2GBvusXsaBhcmJkPNu97OdtsYROY=";
        };
      };
    };
  };

  version = "2025.1.0";

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx";
    rev = "v${version}";
    hash = "sha256-BlPmrfHbpsLI8DCldzoRudpf7T4SUpJXQA5h9o4Thek=";
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

  frontend = buildNpmPackage {
    pname = "pretalx-frontend";
    inherit version src;

    sourceRoot = "${src.name}/src/pretalx/frontend/schedule-editor";

    npmDepsHash = "sha256-8difCdoG7j75wqwuWA/VBRk9oTjsM0QqLnR0iLkd/FY=";

    npmBuildScript = "build";

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

  postPatch = ''
    substituteInPlace src/pretalx/common/management/commands/rebuild.py \
      --replace 'subprocess.check_call(["npm", "run", "build"], cwd=frontend_dir, env=env)' ""
  '';

  nativeBuildInputs = [
    gettext
  ];

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "beautifulsoup4"
    "bleach"
    "beautifulsoup4"
    "celery"
    "css_inline"
    "cssutils"
    "defusedcsv"
    "defusedxml"
    "django-compressor"
    "django-csp"
    "django-filter"
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
      csscompressor
      css-inline
      cssutils
      defusedcsv
      defusedxml
      django
      django-compressor
      django-context-decorator
      django-countries
      django-csp
      django-filter
      django-formset-js-improved
      django-formtools
      django-hierarkey
      django-i18nfield
      django-libsass
      django-scopes
      djangorestframework
      drf-flex-fields
      drf-spectacular
      libsass
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
    rm -r ./src/pretalx/frontend/schedule-editor
    ln -s ${frontend}/lib/node_modules/@pretalx/schedule-editor ./src/pretalx/frontend/schedule-editor

    # Generate all static files, see https://docs.pretalx.org/administrator/commands.html#python-m-pretalx-rebuild
    PYTHONPATH=$PYTHONPATH:./src python -m pretalx rebuild
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ./src/manage.py $out/bin/pretalx-manage

    # The processed source files are in the static output, except for fonts, which are duplicated.
    # See <https://github.com/pretalx/pretalx/issues/1585> for more details.
    find $out/${python.sitePackages}/pretalx/static \
      -mindepth 1 \
      -not -path "$out/${python.sitePackages}/pretalx/static/fonts*" \
      -delete

    # Copy generated static files into dedicated output
    mkdir -p $static
    cp -r ./src/static.dist/** $static/

    # Copy frontend files
    ln -s ${frontend}/lib/node_modules/@pretalx/schedule-editor/dist/* $static
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
    ++ lib.concatAttrValues optional-dependencies;

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
