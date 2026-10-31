{
  callPackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3,
}:
let
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "messages";
    tag = "v${version}";
    hash = "sha256-E2XD5+rZldA7TFYFBnUleWRqCshu0oP+aG7VIfQUKUo=";
  };

  meta = {
    homepage = "https://github.com/suitenumerique/messages";
    changelog = "https://github.com/suitenumerique/messages/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.linux;
  };

  frontend = callPackage ./frontend.nix { inherit src version meta; };

  python = python3.override {
    self = python;
    packageOverrides = (self: super: { django = super.django_5; });
  };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  __structuredAttrs = true;
  pname = "lasuite-messages";
  pyproject = true;
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/src/backend";

  patches = [
    # Allow not to leak secrets into the nix store.
    # https://github.com/suitenumerique/messages/pull/814
    ./secrets.patch
  ];

  build-system = with python.pkgs; [ uv-build ];

  dependencies =
    with python.pkgs;
    [
      boto3
      botocore
      celery
      cryptography
      defusedxml
      dj-database-url
      django
      django-celery-beat
      django-celery-results
      django-configurations
      django-cors-headers
      django-countries
      django-extensions
      django-fernet-encrypted-fields
      django-filter
      django-lasuite
      django-prometheus
      django-redis
      django-storages
      django-timezone-field
      djangorestframework
      dkimpy
      dnspython
      drf-spectacular
      drf-spectacular-sidecar
      google-auth
      httpx
      opensearch-py
      factory-boy
      gunicorn
      icalendar
      jmap-email
      jsonschema
      nested-multipart-parser
      openai
      psycopg
      pyjwt
      pysocks
      python-keycloak
      python-magic
      pyzstd
      redis
      requests
      sentry-sdk
      libpff-python
      url-normalize
      whitenoise
      prometheus-client
      py-vapid
      http-ece
    ]
    ++ celery.optional-dependencies.redis
    ++ django-lasuite.optional-dependencies.all
    ++ httpx.optional-dependencies.http2
    ++ sentry-sdk.optional-dependencies.django;

  pythonRelaxDeps = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.12.0,<0.13.0' 'uv_build' \
      --replace-fail 'name = "messages-backend"' 'name = "messages"'
  '';

  postBuild = ''
    export DJANGO_DATA_DIR=$(pwd)/data
    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic --no-input --clear
  '';

  postInstall =
    let
      pythonPath = python.pkgs.makePythonPath finalAttrs.passthru.dependencies;
    in
    ''
      mkdir -p $out/{bin,share}
      cp ./manage.py $out/bin/.manage.py
      cp -r data/static $out/share
      chmod +x $out/bin/.manage.py
      makeWrapper $out/bin/.manage.py $out/bin/messages \
        --prefix PYTHONPATH : "${pythonPath}"
      makeWrapper ${lib.getExe python.pkgs.celery} $out/bin/celery \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"
      makeWrapper ${lib.getExe python.pkgs.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"
    '';

  passthru = {
    inherit frontend;
    updateScript = nix-update-script { };
  };

  meta = meta // {
    description = "Messages is a full communication platform enabling teams to collaborate on emails through shared or personal mailboxes";
    mainProgram = "messages";
  };
})
