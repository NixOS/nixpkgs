{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, alsa-lib
, cmake
, glib
, pkg-config
, qtbase
, withJack ? stdenv.hostPlatform.isUnix, jack
}:

mkDerivation rec {
  pname = "munt";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "libmt32emu_${lib.replaceChars [ "." ] [ "_" ] version}";
    hash = "sha256-n5VV5Swh1tOVQGT3urEKl64A/w7cY95/0y5wC5ZuLm4=";
  };

  dontFixCmake = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    qtbase
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optional withJack jack;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/${meta.mainProgram}.app $out/Applications/
    ln -s $out/{Applications/${meta.mainProgram}.app/Contents/MacOS,bin}/${meta.mainProgram}
  '';

  meta = with lib; {
    homepage = "http://munt.sourceforge.net/";
    description = "An emulator of Roland MT-32, CM-32L, CM-64 and LAPC-I devices";
    license = with licenses; [ lgpl21 gpl3 ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
    mainProgram = "mt32emu-qt";
  };
}
