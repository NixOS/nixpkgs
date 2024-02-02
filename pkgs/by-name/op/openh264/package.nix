{ lib
, fetchFromGitHub
, nasm
, stdenv
, windows
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openh264";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "openh264";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vPVHXATsSWmqKOAj09WRR5jCi2NU2lq0j4K15KBzARY=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    nasm
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isWindows [
    windows.pthreads
  ];

  # TODO: refine ARCH and OS
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "PREFIX=${placeholder "out"}"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [ "OS=mingw_nt" ];

  enableParallelBuilding = true;

  hardeningDisable = lib.optionals stdenv.hostPlatform.isWindows [
    "stackprotector"
  ];

  meta = {
    homepage = "https://www.openh264.org";
    description = "A codec library which supports H.264 encoding and decoding";
    changelog = "https://github.com/cisco/openh264/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
