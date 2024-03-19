{ lib
, buildNpmPackage
, gettext
, python3
, fetchFromGitHub
, nixosTests
}:

let
  python = python3.override {
    packageOverrides = final: prev: {
      django-bootstrap4 = prev.django-bootstrap4.overridePythonAttrs (oldAttrs: rec {
        version = "3.0.0";
        src = oldAttrs.src.override {
          rev = "v${version}";
          hash = "sha256-a8BopUwZjmvxOzBVqs4fTo0SY8sEEloGUw90daYWfz8=";
        };

        propagatedBuildInputs = with final; [
          beautifulsoup4
          django
        ];

        # fails with some assertions
        doCheck = false;
      });
    };
  };

  version = "2024.1.0";

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx";
    rev = "v${version}";
    hash = "sha256-rFOlovybaEZnv5wBx6Dv8bVkP1D+CgYAKRXuNb6hLKQ=";
  };

  meta = with lib; {
    description = "Conference planning tool: CfP, scheduling, speaker management";
    mainProgram = "pretalx-manage";
    homepage = "https://github.com/pretalx/pretalx";
    changelog = "https://docs.pretalx.org/en/latest/changelog.html";
    license = licenses.asl20;
    maintainers = teams.c3d2.members;
    platforms = platforms.linux;
  };

  frontend = buildNpmPackage {
    pname = "pretalx-frontend";
    inherit version src;

    sourceRoot = "${src.name}/src/pretalx/frontend/schedule-editor";

    npmDepsHash = "sha256-B9R3Nn4tURNxzeyLDHscqHxYOQK9AcmDnyNq3k5WQQs=";

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

    substituteInPlace src/setup.cfg \
      --replace "--cov=./ --cov-report=" ""
  '';

  nativeBuildInputs = [
    gettext
  ];

  propagatedBuildInputs = with python.pkgs; [
    beautifulsoup4
    bleach
    celery
    css-inline
    csscompressor
    cssutils
    defusedcsv
    django
    django-bootstrap4
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
  ] ++ beautifulsoup4.optional-dependencies.lxml;

  passthru.optional-dependencies = {
    mysql = with python.pkgs; [
      mysqlclient
    ];
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

  nativeCheckInputs = with python.pkgs; [
    faker
    freezegun
    jsonschema
    pytest-django
    pytest-mock
    pytest-xdist
    pytestCheckHook
    responses
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
  ];

  passthru = {
    inherit python;
    tests = {
      inherit (nixosTests) pretalx;
    };
  };

  inherit meta;
}
