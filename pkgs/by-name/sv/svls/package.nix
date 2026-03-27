{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "svls";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-dLAlXsvUno6bx67A3knevo0ZRBMNOlWW3CmNfgCgha4=";
  };

  cargoHash = "sha256-7q6VeMjnDE4N35Kk6w4T9Za2VquibuvitGVWTvHvvgs=";

  meta = {
    description = "SystemVerilog language server";
    mainProgram = "svls";
    homepage = "https://github.com/dalance/svls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ trepetti ];
  };
})
