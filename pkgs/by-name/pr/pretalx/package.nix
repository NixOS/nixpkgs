{
  lib,
  buildNpmPackage,
  gettext,
  python3,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  plugins ? [ ],
  nixosTests,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
<<<<<<< HEAD
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
    };
  };

  version = "2025.2.2";
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-2qru52/ZALBAdRh0I+3VimVsiRl71YZgbSUD/LdoA/0=";
=======
    rev = "v${version}";
    hash = "sha256-BlPmrfHbpsLI8DCldzoRudpf7T4SUpJXQA5h9o4Thek=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  pretix-schedule-editor = buildNpmPackage {
    pname = "pretalx-schedule-editor";
=======
  frontend = buildNpmPackage {
    pname = "pretalx-frontend";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit version src;

    sourceRoot = "${src.name}/src/pretalx/frontend/schedule-editor";

<<<<<<< HEAD
    npmDepsHash = "sha256-voHiml0nFWZIST39D5ErB0xTiWAOHN9OZinYutuQcdg=";

    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp dist/** $out/

      runHook postInstall
    '';

=======
    npmDepsHash = "sha256-8difCdoG7j75wqwuWA/VBRk9oTjsM0QqLnR0iLkd/FY=";

    npmBuildScript = "build";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  patches = [
    # don't run npm during rebuild command, we already use a separate derivation
    # to build static assets
    ./rebuild-no-npm.patch
  ];
=======
  postPatch = ''
    substituteInPlace src/pretalx/common/management/commands/rebuild.py \
      --replace 'subprocess.check_call(["npm", "run", "build"], cwd=frontend_dir, env=env)' ""
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    gettext
  ];

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "beautifulsoup4"
    "bleach"
<<<<<<< HEAD
=======
    "beautifulsoup4"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "celery"
    "css_inline"
    "cssutils"
    "defusedcsv"
    "defusedxml"
<<<<<<< HEAD
    "django-csp"
    "django-filter"
    "django-formset-js-improved"
=======
    "django-compressor"
    "django-csp"
    "django-filter"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
      csscompressor
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      css-inline
      cssutils
      defusedcsv
      defusedxml
<<<<<<< HEAD
      diff-match-patch
      django
=======
      django
      django-compressor
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      django-context-decorator
      django-countries
      django-csp
      django-filter
      django-formset-js-improved
      django-formtools
      django-hierarkey
      django-i18nfield
<<<<<<< HEAD
      django-minify-html
      django-scopes
      django-tables2
      djangorestframework
      drf-flex-fields
      drf-spectacular
=======
      django-libsass
      django-scopes
      djangorestframework
      drf-flex-fields
      drf-spectacular
      libsass
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    # link schedule-editor so it can be picked up in staticfiles lookups
    ln -s ${pretix-schedule-editor}/** ./src/pretalx/static/
=======
    rm -r ./src/pretalx/frontend/schedule-editor
    ln -s ${frontend}/lib/node_modules/@pretalx/schedule-editor ./src/pretalx/frontend/schedule-editor
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    # Generate all static files, see https://docs.pretalx.org/administrator/commands.html#python-m-pretalx-rebuild
    PYTHONPATH=$PYTHONPATH:./src python -m pretalx rebuild
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ./src/manage.py $out/bin/pretalx-manage

<<<<<<< HEAD
    # Copy and merge static files
    mkdir -p $static
    cp -r ./src/static.dist/** $static/
    cp -r ${pretix-schedule-editor}/** $static/

    # And link them into the package for staticfiles lookups
    rm -rf $out/${python.sitePackages}/pretalx/static
    ln -s $static/ $out/${python.sitePackages}/pretalx/static
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    ++ lib.concatAttrValues optional-dependencies;
=======
    ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
