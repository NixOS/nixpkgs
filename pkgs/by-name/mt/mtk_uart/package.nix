{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libusb1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mtk_uartboot";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "981213";
    repo = "mtk_uartboot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mwwm2TVBfOEqvQIP0Vl4Q2SkcZxX1JP7rShmjaY+pWE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DtYCSPcyLDYeo9fIQpHGdm5r6ijRAzsDExWcDuSvh/o=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  meta = {
    description = "A tool for MediaTek UART boot mode";
    homepage = "https://github.com/981213/mtk_uartboot";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ phodina ];
    mainProgram = "mtk_uartboot";
  };
})
