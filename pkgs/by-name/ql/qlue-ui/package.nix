{
  lib,
  python3Packages,
  fetchFromGitHub,
  callPackage,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "qlue-ui";
  version = "0-unstable-2026-11-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qlever-dev";
    repo = "qlue-ui";
    rev = "0cf882c7de7d4a5b0a567e5cbcc7e3ab85a8bc1d";
    hash = "sha256-3r3pmmo8nfGmVlTRFT8fOwDkjd/rkW7xCxhQocBqdzw=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '[standard]' ""
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    fastapi
    pydantic
    pyyaml
    uvicorn
    watchdog
  ];

  pythonRelaxDeps = true;

  postInstall = ''
    makeWrapper ${python3Packages.uvicorn}/bin/uvicorn $out/bin/qlue-ui \
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:$PYTHONPATH" \
      --set-default FRONTEND_DIR "${finalAttrs.passthru.frontend}" \
      --add-flags "api.main:app"
  '';

  pythonImportsCheck = [
    "api"
  ];

  passthru = {
    frontend = callPackage ./frontend.nix { };
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
        "--subpackage=frontend"
      ];
    };
  };

  meta = {
    description = "Web-based query UI and SPARQL editor for QLever";
    homepage = "https://github.com/qlever-dev/qlue-ui";
    license = lib.licenses.asl20;
    mainProgram = "qlue-ui";
    teams = with lib.teams; [ ngi ];
  };
})
