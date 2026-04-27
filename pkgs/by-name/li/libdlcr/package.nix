{
  stdenv,
  lib,
  fetchzip,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdlcr";
  version = "0.3.0";

  src = fetchzip {
    url = "https://dragnlabs.com/host-tools/dlcr_host_v${finalAttrs.version}.zip";
    hash = "sha256-DOoc02woE10tU+8CDaYC0Xezvma06+UbhVuGFEiG67c=";
    stripRoot = false;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libusb1 ];

  postPatch = ''
    # Workaround based on
    # https://github.com/NixOS/nixpkgs/issues/144170

    substituteInPlace libdlcr.pc.in --replace-fail "\''${prefix}/" ""
  '';

  meta = {
    description = "Dragon Labs CR-8 Host Driver and Utilities";
    homepage = "https://dragnlabs.com/";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ noderyos ];
  };
})
