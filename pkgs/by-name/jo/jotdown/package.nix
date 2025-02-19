{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-1s0J6TF/iDSqKUF4/sgq2irSPENjinftPFZnMgE8Dn8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SGmlNpauPk2qSIIdP0hfGUplCV9ZvyHhZss8XXuxfHg=";

  meta = with lib; {
    description = "Minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
