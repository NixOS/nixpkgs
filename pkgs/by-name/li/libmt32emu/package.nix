{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmt32emu";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    tag = "libmt32emu_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-wXIvdGoup/AOQggkeXvtbi3pXhyKUKWmyt/ZbGzufds=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-Dmunt_WITH_MT32EMU_SMF2WAV=OFF"
    "-Dmunt_WITH_MT32EMU_QT=OFF"
  ];

  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/mt32emu.pc \
      --replace '=''${exec_prefix}//' '=/' \
      --replace "$dev/$dev/" "$dev/"
  '';

  meta = {
    homepage = "https://munt.sourceforge.net/";
    description = "Library to emulate Roland MT-32, CM-32L, CM-64 and LAPC-I devices";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix; # Not tested on ReactOS yet :)
  };
})
