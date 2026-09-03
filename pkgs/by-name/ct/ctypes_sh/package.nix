{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  zlib,
  libffi,
  elfutils,
  libdwarf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctypes.sh";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "taviso";
    repo = "ctypes.sh";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZYsjySJaxyLAiyGaNwngA7ef6vA+fUTCh9hi5g55v+g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    zlib
    libffi
    elfutils
    libdwarf
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  meta = {
    description = "Foreign function interface for bash";
    mainProgram = "ctypes.sh";
    homepage = "https://github.com/taviso/ctypes.sh";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
