{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libusb1,
  nix-update-script,
  pkg-config,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libperseus-sdr";
  version = "0.8.2";
  src = fetchFromGitHub {
    owner = "Microtelecom";
    repo = "libperseus-sdr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sjWaR9APDNr6sR9G8wn1nnR2yb4Wu0g4h8xO4zp1uzM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    xxd
  ];

  buildInputs = [ libusb1 ];

  postPatch = ''
    patchShebangs generate_fpga_code.sh
  '';

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Perseus Software Defined Radio Control Library for Linux";
    homepage = "http://microtelecom.it/perseus/";
    downloadPage = "https://github.com/Microtelecom/libperseus-sdr/releases";
    changelog = "https://github.com/Microtelecom/libperseus-sdr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ VZstless ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
