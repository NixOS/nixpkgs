{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmt32emu";
<<<<<<< HEAD
  version = "2.7.3";
=======
  version = "2.7.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    tag = "libmt32emu_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-3sL9ZDM4/70vKPkOU6Et82c3RC5OYt0eQb5miDYRU0I=";
=======
    hash = "sha256-wXIvdGoup/AOQggkeXvtbi3pXhyKUKWmyt/ZbGzufds=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
