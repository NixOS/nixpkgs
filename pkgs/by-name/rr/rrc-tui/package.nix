{ lib,
  fetchFromGitHub,
  python3Packages,
}:

with python3Packages;
buildPythonApplication rec {
  pname = "rrc-tui";
  version = "0.1.0-unstable-2026-01-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kc1awv";
    repo = "rrc-tui";
    rev = "c3edb67479133e23fe5d72d1de56c734be0d120f";
    hash = "sha256-qVL/XqxUdabaQZGOKpTfETmTUC7tcTdXWht//bcecHI=";
  };

  dependencies = [
    rns
    textual
    cbor2
  ];

  buildInputs = [
    setuptools
  ];

  outputs = [ "out" ];

  meta = {
    homepage = "https://github.com/kc1awv/rrc-tui";
    description = "A Text User Interface (TUI) client for RRC (Reticulum Relay Chat)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      stellarskylark
    ];
    platforms = lib.platforms.linux;
    mainProgram = "rrc-tui";
  };

}
