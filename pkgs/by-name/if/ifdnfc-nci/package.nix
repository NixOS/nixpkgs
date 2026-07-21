{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  pcsclite,
  libnfc-nci,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ifdnfc-nci";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "StarGate01";
    repo = "ifdnfc-nci";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-I2MNzmaxQUh4bN3Uytf2bQRthByEaFWM7c79CKZJQZA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pcsclite
    libnfc-nci
  ];

  meta = {
    description = "PC/SC IFD Handler based on linux_libnfc-nci";
    homepage = "https://github.com/StarGate01/ifdnfc-nci";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ stargate01 ];
  };
})
