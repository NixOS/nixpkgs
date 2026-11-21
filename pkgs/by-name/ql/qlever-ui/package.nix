{
  lib,
  python3Packages,
  fetchFromGitHub,
  callPackage,
  qlever-ui-frontend ? callPackage ./frontend.nix { },
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "qlever-ui";
  version = "0-unstable-2026-04-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qlever-dev";
    repo = "qlever-ui";
    rev = "ae139a1cd5ebd704e0eb273c8ca57b8a689184e7";
    hash = "sha256-DIlmSaRdOJXDj3HvAxnSzmEr6595x9Avcg0jWH9fUuU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    django
    django-environ
    django-import-export
    djangorestframework
    gunicorn
    markdown
    pyyaml
    requests
    whitenoise
  ];

  pythonRelaxDeps = [
    "django"
    "django-environ"
    "gunicorn"
    "requests"
    "whitenoise"
  ];

  preBuild = ''
    cp -r ${qlever-ui-frontend}/. ./backend/static/wasm/
  '';

  postInstall = ''
    makeWrapper ${python3Packages.gunicorn}/bin/gunicorn \
      $out/bin/qlever-ui \
      --add-flags "qlever.wsgi:application" \
      --add-flags "--limit-request-line 10000" \
      --prefix PYTHONPATH : "$PYTHONPATH"

    cp -r $PWD $out/opt

    makeWrapper $out/opt/manage.py \
      $out/bin/qlever-ui-manage \
      --set DJANGO_SETTINGS_MODULE qlever.settings \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  pythonImportsCheck = [
    "qlever"
  ];

  passthru = {
    frontend = qlever-ui-frontend;
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
        "--subpackage=frontend"
      ];
    };
  };

  meta = {
    description = "User interface for QLever";
    homepage = "https://github.com/qlever-dev/qlever-ui";
    mainProgram = "qlever-ui";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
  };
})
