{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "gimoji";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = version;
    hash = "sha256-X1IiDnnRXiZBL/JBDfioKc/724TnVKaEjZLrNwX5SoA=";
  };

  cargoHash = "sha256-vAhHCNsViYyNSKeSGUL2oIp8bp5UCm8HReyDuoFvfqs=";

  meta = with lib; {
    description = "Easily add emojis to your git commit messages";
    homepage = "https://github.com/zeenix/gimoji";
    license = licenses.mit;
    mainProgram = "gimoji";
    maintainers = with maintainers; [ a-kenji ];
  };
}
