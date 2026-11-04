{
  lib,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "icosa-gallery";
  version = "0-unstable-2026-11-04";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "icosa-foundation";
    repo = "icosa-gallery";
    rev = "d070c1aa199535b6755eb230e805552d2e4c96e7";
    hash = "sha256-f8cl03eGI0fyYKjSvd1p5OUWw8mH1ohHsQwpHyB/lsM=";
  };

  sourceRoot = "${finalAttrs.src.name}/django";

  patches = [
    ./BASE_DIR.patch
    # See https://github.com/icosa-foundation/icosa-gallery/pull/200
    ./0001-Fix-django-ninja-removed-Config.patch
  ];

  dependencies =
    with python3Packages;
    [
      b2sdk
      bcrypt
      boto3
      botocore
      django
      django-async-extensions
      django-autocomplete-light
      django-axes
      django-compressor
      django-constance
      django-cors-headers
      django-debug-toolbar
      django-extensions
      django-honeypot
      django-import-export
      django-libsass
      django-maintenance-mode
      django-ninja
      django-ratelimit
      django-redis
      django-simple-math-captcha
      django-storages
      enforced-permissions
      huey
      ijson
      ixxy-email-logger
      passlib
      pillow
      psycopg
      psycopg-pool
      pydantic
      pyjwt
      python-magic
      requests
      s3transfer
      sentry-sdk
      uvicorn
    ]
    ++ django-import-export.optional-dependencies.all
    ++ pydantic.optional-dependencies.email
    ++ sentry-sdk.optional-dependencies.django;

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/icosa-gallery
    cp -r django_project icosa gunicorn_config $out/opt/icosa-gallery

    mkdir -p $out/bin
    cp -r manage.py $out/bin/icosa-gallery

    ln -s ${lib.getExe python3Packages.uvicorn} $out/opt/icosa-gallery/uvicorn

    runHook postInstall
  '';

  preFixup = ''
    makeWrapperArgs+=(--prefix PYTHONPATH : "$out/opt/icosa-gallery")
  '';

  postFixup =
    let
      pythonPath = python3Packages.makePythonPath finalAttrs.finalPackage.dependencies;
    in
    ''
      wrapProgram $out/opt/icosa-gallery/uvicorn \
        --prefix PYTHONPATH : "$out/opt/icosa-gallery:${pythonPath}"
    '';

  passthru.tests = {
    inherit (nixosTests) icosa-gallery;
  };

  meta = {
    description = "3D model hosting solution";
    homepage = "https://github.com/icosa-foundation/icosa-gallery";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
    mainProgram = "icosa-gallery";
  };
})
