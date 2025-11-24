{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  mbelib,
  serialdv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dsdcc";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "dsdcc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4wSf4pOEheuhW4ReEDo5i3poiHMC0wgSUk2lXBYWjOs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    mbelib
    serialdv
  ];

  cmakeFlags = [
    "-DUSE_MBELIB=ON"
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/libdsdcc.pc \
      --replace '=''${exec_prefix}//' '=/'
  '';

  meta = {
    description = "Digital Speech Decoder (DSD) rewritten as a C++ library";
    homepage = "https://github.com/f4exb/dsdcc";
    license = lib.licenses.gpl3;
    mainProgram = "dsdccx";
    maintainers = with lib.maintainers; [ alexwinter ];
    platforms = lib.platforms.unix;
  };
})
