{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "siomon";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "level1techs";
    repo = "siomon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OdMCY8/E+iKT4XCt4slgzhEefj3952vsc0X6L9mGXxU=";
  };

  cargoHash = "sha256-qIdV2DxjuHbWXvMTUClz7CKqxXSmeF70C+flQTsuSIg=";

  meta = {
    description = "A comprehensive Linux hardware information and real-time sensor monitoring tool. Single static binary, no runtime dependencies.";
    homepage = "https://github.com/level1techs/siomon";
    changelog = "https://github.com/level1techs/siomon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sheevy ];
    mainProgram = "sio";
  };
})
