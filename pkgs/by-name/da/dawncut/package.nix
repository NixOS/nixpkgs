{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dawncut";
  version = "1.54a";

  src = fetchurl {
    name = "${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    url = "https://geant4.kek.jp/~tanaka/src/dawncut_${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
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

  meta = {
    description = "Tool to generate a 3D scene data clipped with an arbitrary plane";
    license = lib.licenses.unfree;
    homepage = "https://geant4.kek.jp/~tanaka/DAWN/About_DAWNCUT.html";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
