{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  gmp,
  ncurses,
  zlib,
  readline,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "saw-tools";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/GaloisInc/saw-script/releases/download/v${finalAttrs.version}/saw-${finalAttrs.version}-ubuntu-22.04-X64-with-solvers.tar.gz";
    hash = "sha256-1t1uGAQXCBC//RNBxQfZIfg00At600An9HaEIcVBEy0=";
  };

  buildInputs = [
    gmp
    ncurses
    readline
    stdenv.cc.libc
    zlib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/lib $out/share

    mv bin $out/bin
    mv doc $out/share

    wrapProgram "$out/bin/saw" --prefix PATH : "$out/bin/"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "saw --version";
  };

  meta = {
    description = "Tools for software verification and analysis";
    homepage = "https://saw.galois.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
})
