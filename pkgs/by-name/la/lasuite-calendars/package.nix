{
  lib,
  python3Packages,
  fetchFromGitHub,
  python3,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lasuite-calendars";
  version = "unstable-2026-04-20";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "calendars";
    rev = "f70d7164f827bbb050b8b810eac055b9e538645a";
    hash = "sha256-fY6OGFq91FzVp2W4iiE1QLgguusBJExNpRGorUsSLLc=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/backend";

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    [
      brotli
      caldav
      dj-database-url
      django
      django-configurations
      django-cors-headers
      django-countries
      django-debug-toolbar
      django-dramatiq
      django-extensions
      django-fernet-encrypted-fields
      django-filter
      django-lasuite
      django-parler
      django-redis
      django-timezone-field
      djangorestframework
      djangorestframework-api-key
      dramatiq
      drf-spectacular
      drf-spectacular-sidecar
      drf-standardized-errors
      factory-boy
      gunicorn
      jsonschema
      mozilla-django-oidc
      nested-multipart-parser
      pillow
      psycopg
      pyjwt
      redis
      requests
      sentry-sdk
      url-normalize
      whitenoise
    ]
    ++ dramatiq.optional-dependencies.redis
    ++ django-lasuite.optional-dependencies.all;

  pythonRelaxDeps = true;

  postBuild = ''
    export DATA_DIR=$(pwd)/data
    ${python3.pythonOnBuildForHost.interpreter} manage.py collectstatic --no-input --clear
  '';

  postInstall =
    let
      pythonPath = python3Packages.makePythonPath finalAttrs.passthru.dependencies;
    in
    ''
      mkdir -p $out/{bin,share}

      cp ./manage.py $out/bin/.manage.py
      cp ./worker.py $out/bin/.worker.py
      cp -r data/static $out/share
      chmod +x $out/bin/{.manage,.worker}.py

      makeWrapper $out/bin/.manage.py $out/bin/calendars \
        --prefix PYTHONPATH : "${pythonPath}"
      makeWrapper $out/bin/.worker.py $out/bin/dramatiq \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python3.sitePackages}"
      makeWrapper ${lib.getExe python3Packages.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python3.sitePackages}"

      mkdir -p $out/${python3.sitePackages}/core/templates

      cp -r calendars/configuration $out/${python3.sitePackages}/calendars/configuration
    '';

  meta = {
    description = "A modern, open-source calendar application for managing events and schedules";
    homepage = "https://github.com/suitenumerique/calendars";
    changelog = "https://github.com/suitenumerique/calendars/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      soyouzpanda
    ];
    platforms = lib.platforms.all;
  };
})
