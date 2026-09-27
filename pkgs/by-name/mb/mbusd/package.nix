{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbusd";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "3cky";
    repo = "mbusd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JCDDoyDh1mlnZSfthKfFT+NjVAm3Menzm5FvfMgQYmw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "Modbus TCP to Modbus RTU (RS-232/485) gateway";
    homepage = "https://github.com/3cky/mbusd";
    changelog = "https://github.com/3cky/mbusd/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
    mainProgram = "mbusd";
  };
})
