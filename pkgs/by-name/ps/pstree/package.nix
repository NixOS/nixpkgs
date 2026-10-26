{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pstree";
  version = "2.39";

  src = fetchurl {
    urls = [
      "https://distfiles.macports.org/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz"
      "https://fossies.org/linux/misc/${finalAttrs.pname}-${finalAttrs.version}.tar.gz"
      "ftp://ftp.thp.uni-duisburg.de/pub/source/${finalAttrs.pname}-${finalAttrs.version}.tar.gz"
    ];
    sha256 = "17s7v15c4gryjpi11y1xq75022nkg4ggzvjlq2dkmyg67ssc76vw";
  };

  sourceRoot = ".";
  buildPhase = ''
    runHook preBuild
    $CC $NIX_CFLAGS -o pstree pstree.c
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm0555 ${finalAttrs.pname} -t $out/bin
    install -Dm0444 ${finalAttrs.pname}.1 -t $out/share/man/man1
    runHook postInstall
  '';

  meta = {
    description = "Show the set of running processes as a tree";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    priority = 5; # Lower than psmisc also providing pstree on Linux platforms
    mainProgram = "pstree";
  };
})
