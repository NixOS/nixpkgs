{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lethe";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = "lethe";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nhiilGNWsWBFZV32TqVdKCQJCPN2WLYeXCVRBK7uTQY=";
  };

  cargoHash = "sha256-MazZz6N+NKlgDrGs9sTiblYDUg9l3ItXFbB1NRk1LTw=";

  meta = {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lethe";
  };
})
