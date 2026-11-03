{
  lib,
  callPackage,
  python3Packages,
  fetchFromGitea,
  nixosTests,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "karrot";
  version = "17.4.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "karrot";
    repo = "karrot-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aCfbFBN89ToYASmxpeaKzi7+BXtyfqlPr4EmXmTYRHA=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  postPatch = ''
    substituteInPlace karrot/cli.py \
      --replace-fail 'core_settings.listen.port,' 'str(core_settings.listen.port),' \
      --replace-fail 'os.execv(' 'os.environ["PYTHONPATH"] = os.pathsep.join(sys.path); os.execv('

    substituteInPlace karrot/utils/email_trimming.py \
      --replace-fail \
        'return html_to_markdown.convert(html, html_to_markdown.ConversionOptions(extract_metadata=False))' \
        'res = html_to_markdown.convert(html, html_to_markdown.ConversionOptions(extract_metadata=False)); return getattr(res, "content", res)'

    cp -r ${finalAttrs.passthru.emailTemplates}/karrot/* karrot/

    cat >> MANIFEST.in << 'EOF'
    graft karrot
    graft config
    EOF

    cat >> pyproject.toml << 'EOF'

    [build-system]
    requires = ["setuptools>=61.0"]
    build-backend = "setuptools.build_meta"

    [project]
    name = "karrot"
    version = "${finalAttrs.version}"

    [project.scripts]
    karrot = "karrot.cli:cli"

    [tool.setuptools]
    include-package-data = true

    [tool.setuptools.packages.find]
    include = ["karrot*", "config*"]
    EOF
  '';

  preBuild = ''
    export PYTHONPATH=".:$PYTHONPATH"
    export MODE=dev
    export SECRET_KEY=dummy
    python3 -c "import os, django; from django.core.management import call_command; os.environ['DJANGO_SETTINGS_MODULE'] = 'config.settings'; django.setup(); call_command('collectstatic', '--noinput')"
    find . -type d -name __pycache__ -prune -exec rm -rf {} +
  '';

  makeWrapperArgs = [
    "--set-default"
    "FRONTEND_DIR"
    "${finalAttrs.passthru.frontend}"
  ];

  dependencies =
    with python3Packages;
    [
      aiofiles
      argon2-cffi
      asgiref
      babel
      bleach
      bleach-allowlist
      channels
      channels-redis
      click
      cryptography
      daphne
      deepmerge
      django
      django-anymail
      django-cors-headers
      django-crispy-forms
      django-dirtyfields
      django-enumfield
      django-extensions
      django-filter
      django-jinja
      django-redis
      django-silk
      django-timezone-field
      django-versatileimagefield
      django-watchfiles
      djangorestframework
      djangorestframework-csv
      drf-orjson-renderer
      drf-pydantic
      drf-spectacular
      drf-spectacular-sidecar
      email-validator
      factory-boy
      faker
      fractional-indexing
      freezegun
      furl
      geoip2
      gevent
      glom
      gunicorn
      hiredis
      html-to-markdown
      html2text
      httpx
      huey
      icalendar
      influxdb
      livekit-api
      logging-tree
      markdown
      more-itertools
      pillow
      psutil
      psycopg
      py-vapid
      pycrdt
      pydantic
      pymdown-extensions
      python-dateutil
      python-dotenv
      python-gnupg
      pytz
      pywebpush
      redis
      requests
      rich
      sentry-sdk
      sqlparse
      starlette
      talon-core
      traitlets
      typing-extensions
      tzdata
      unidecode
      urllib3
      uvicorn
    ]
    ++ uvicorn.optional-dependencies.standard;

  pythonImportsCheck = [
    "karrot"
  ];

  passthru = {
    emailTemplates = callPackage ./email-templates.nix { };
    frontend = callPackage ./frontend.nix { };
    tests = {
      inherit (nixosTests) karrot;
    };

    # We follow version from https://codeberg.org/karrot/karrot repo not karrot-backend latest tag
    updateScript = nix-update-script {
      extraArgs = [
        "--url=https://codeberg.org/karrot/karrot"
        "--subpackage=emailTemplates"
        "--subpackage=frontend"
      ];
    };
  };

  meta = {
    description = "Tool for grassroots initiatives and groups to coordinate face-to-face activities";
    homepage = "https://karrot.world/";
    changelog = "https://codeberg.org/karrot/karrot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    teams = with lib.teams; [ ngi ];
    mainProgram = "karrot";
  };
})
