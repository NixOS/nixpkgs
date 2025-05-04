{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  python3,
  python3Packages,
}:
mkEspansoPlugin {
  pname = "delays-characters";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  buildInputs = [
    python3
    python3Packages.pynput
  ];

  meta = {
    description = "A package to allow delays, and characters not supported by Espanso, to be injected using the Python pynput library.";
    homepage = "https://github.com/smeech";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
