{
  lib,
  fetchFromGitHub,
  python3,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rns-page-node";
  version = "1.1.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sudo-Ivan";
    repo = "rns-page-node";
    tag = "v${version}";
    hash = "sha256-Bgy3DWsixMQlEOGuZIT1y+U8Uu9V8/yJnFObuMZJ8a0=";
  };

  doCheck = true;

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    poetry-core
  ];

  dependencies = with python3.pkgs; [ rns ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Sudo-Ivan/rns-page-node";
    changelog = "https://github.com/Sudo-Ivan/rns-page-node/releases/tag/${src.tag}";
    description = "Program to serve pages and files over the Reticulum network";
    mainProgram = "rns-page-node";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ qbit ];
  };
}
