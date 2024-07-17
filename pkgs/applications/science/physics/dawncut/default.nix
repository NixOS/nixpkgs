{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "dawncut";
  version = "1.54a";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://geant4.kek.jp/~tanaka/src/dawncut_${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }.taz";
    hash = "sha256-Ux4fDi7TXePisYAxCMDvtzLYOgxnbxQIO9QacTRrT6k=";
  };

  postPatch = ''
    substituteInPlace Makefile.architecture \
      --replace 'CXX      := g++' ""
  '';

  dontConfigure = true;

  env.NIX_CFLAGS_COMPILE = "-std=c++98";

  installPhase = ''
    runHook preInstall

    install -Dm 500 dawncut "$out/bin/dawncut"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A tool to generate a 3D scene data clipped with an arbitrary plane";
    license = licenses.unfree;
    homepage = "https://geant4.kek.jp/~tanaka/DAWN/About_DAWNCUT.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
