{
  lib,
  fetchFromGitHub,
  python311,
  dooit,
  nix-update-script,
}:
let
  python3 = python311;
in
python3.pkgs.buildPythonPackage rec {
  pname = "dooit-extras";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dooit-org";
    repo = "dooit-extras";
    tag = "v${version}";
    hash = "sha256-ZBzzH8k4oC3ovLF9+9rzzFZaDDoOvcbX5NCh1WBedK4=";
  };

  build-system = with python3.pkgs; [ poetry-core ];
  buildInputs = [ dooit ];

  # No tests available
  doCheck = false;

  passthru.updateScript = nix-update-script {
  };

  meta = with lib; {
    description = "Extra Utilities for Dooit";
    homepage = "https://github.com/dooit-org/dooit-extras";
    changelog = "https://github.com/dooit-org/dooit-extras/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      kraanzu
    ];
  };
}
