{ lib, stdenv, fetchurl, installShellFiles }:
let
  man = fetchurl {
    url = "https://web.archive.org/web/20230608093053if_/http://www.ansikte.se/ARAGORN/Downloads/aragorn.1";
    hash = "sha256-bjD22dpkQZcGR0TwMxdpaed4VZZO2NUOoAw4o66iyS4=";
  };
in

stdenv.mkDerivation rec {
  version = "1.2.41";
  pname = "aragorn";

  src = fetchurl {
    url = "http://www.ansikte.se/ARAGORN/Downloads/aragorn${version}.c";
    hash = "sha256-kqMcxcCwrRbU17AZkZibd18H0oFd8TX+bj6riPXpf0o=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  buildPhase = ''
    $CC -O3 -ffast-math -finline-functions -o aragorn $src
  '';

  installPhase = ''
    mkdir -p $out/bin && cp aragorn $out/bin
    installManPage ${man}
  '';

  meta = with lib; {
    description = "Detects tRNA, mtRNA, and tmRNA genes in nucleotide sequences";
    homepage = "http://www.ansikte.se/ARAGORN/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
