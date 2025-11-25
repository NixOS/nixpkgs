{
  fetchFromGitHub,
  lib,
  makeWrapper,
  python3,
}:
let
  python3' = python3.override {
    packageOverrides = final: prev: {
      django = final.django_5;
      django-admin-tools = final.callPackage ./django-admin-tools.nix { };
      django-constance = final.callPackage ./django-constance.nix { };
      django-honeypot = final.callPackage ./django-honeypot.nix { };
      django-simple-math-captcha = final.callPackage ./django-simple-math-captcha.nix { };
      ixxy-email-logger = final.callPackage ./ixxy-email-logger.nix { };
    };
  };
  python3Packages = python3'.pkgs;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "icosa-gallery";
  version = "0-unstable-2026-01-15";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "icosa-foundation";
    repo = "icosa-gallery";
    rev = "2fc0fe9505f682b8c11f1b282355790c7eb78e0c";
    hash = "sha256-w/PF/65eIkg9OgIzWw8VEGKVuepEf8C/xXjeyiLzH+I=";
  };

  sourceRoot = "${finalAttrs.src.name}/django";

  patches = [
    ./BASE_DIR.patch
  ];

  dependencies =
    with python3Packages;
    [
      django-admin-tools
      django-constance
      django-honeypot
      django-simple-math-captcha
      ixxy-email-logger

      b2sdk
      bcrypt
      boto3
      botocore
      django-autocomplete-light
      django-axes
      django-compressor
      django-cors-headers
      django-debug-toolbar
      django-extensions
      django-ratelimit
      django-redis
      django-import-export
      django-libsass
      django-maintenance-mode
      django-ninja
      django-silk
      django-storages
      django
      gevent
      gunicorn
      huey
      ijson
      passlib
      pillow
      psycopg2
      pydantic
      pyjwt
      python-magic
      requests
      s3transfer
      sentry-sdk
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
    cp -r django_project icosa $out/opt/icosa-gallery

    mkdir -p $out/bin
    cp -r manage.py $out/bin/icosa-gallery

    ln -s ${lib.getExe python3Packages.gunicorn} $out/opt/icosa-gallery/gunicorn

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
      wrapProgram $out/opt/icosa-gallery/gunicorn \
        --prefix PYTHONPATH : "$out/opt/icosa-gallery:${pythonPath}"
    '';

  meta = {
    description = "3D model hosting solution";
    homepage = "https://github.com/icosa-foundation/icosa-gallery";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
    mainProgram = "icosa-gallery";
  };
})
