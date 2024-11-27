{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pstree";
  version = "2.39";

  src = fetchurl {
    urls = [
      "https://distfiles.macports.org/${pname}/${pname}-${version}.tar.gz"
      "https://fossies.org/linux/misc/${pname}-${version}.tar.gz"
      "ftp://ftp.thp.uni-duisburg.de/pub/source/${pname}-${version}.tar.gz"
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
    install -Dm0555 ${pname} -t $out/bin
    install -Dm0444 ${pname}.1 -t $out/share/man/man1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Show the set of running processes as a tree";
    homepage = "http://www.thp.uni-duisburg.de/pstree/";
    license = licenses.gpl2;
    maintainers = [ maintainers.c0bw3b ];
    platforms = platforms.unix;
    priority = 5; # Lower than psmisc also providing pstree on Linux platforms
    mainProgram = "pstree";
  };
}
