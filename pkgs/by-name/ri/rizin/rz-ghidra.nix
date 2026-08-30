{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # buildInputs
  rizin,
  openssl,
  pugixml,
  # optional buildInputs
  enableCutterPlugin ? true,
  cutter,
  qt6,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rz-ghidra";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "rz-ghidra";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R9wPmt2WoK4wlTXb0JUX+0Fk8JQgGagb8vZQmjxLXn8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    openssl
    pugixml
    rizin
    zlib
  ]
  ++ lib.optionals enableCutterPlugin [
    cutter
    qt6.qt5compat
    qt6.qtbase
    qt6.qtsvg
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DUSE_SYSTEM_PUGIXML=ON"
  ]
  ++ lib.optionals enableCutterPlugin [
    "-DBUILD_CUTTER_PLUGIN=ON"
    "-DCUTTER_INSTALL_PLUGDIR=share/rizin/cutter/plugins/native"
  ];

  meta = {
    # errors out with undefined symbols from Cutter
    broken = enableCutterPlugin && stdenv.hostPlatform.isDarwin;
    description = "Deep ghidra decompiler and sleigh disassembler integration for rizin";
    homepage = finalAttrs.src.meta.homepage;
    changelog = "${finalAttrs.src.meta.homepage}/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ chayleaf ];
    inherit (rizin.meta) platforms;
  };
})
