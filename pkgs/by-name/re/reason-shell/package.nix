{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "reason";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "jaywonchung";
    repo = "reason";
    rev = "v${version}";
    hash = "sha256-oytRquZJgb1sfpZil1bSGwIIvm+5N4mkVmIMzWyzDco=";
  };

  cargoHash = "sha256-LXVP8cAbPCPCE3DNBX2znyFn/E/cN2civX0qT0B5FVw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Shell for research papers";
    mainProgram = "reason";
    homepage = "https://github.com/jaywonchung/reason";
    changelog = "https://github.com/jaywonchung/reason/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
