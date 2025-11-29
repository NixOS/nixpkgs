{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-dLAlXsvUno6bx67A3knevo0ZRBMNOlWW3CmNfgCgha4=";
  };

  cargoHash = "sha256-7q6VeMjnDE4N35Kk6w4T9Za2VquibuvitGVWTvHvvgs=";

  meta = with lib; {
    description = "SystemVerilog language server";
    mainProgram = "svls";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
