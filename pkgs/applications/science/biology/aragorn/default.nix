<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, installShellFiles
}:
let
  man = fetchurl {
    url = "https://web.archive.org/web/20230608093053if_/http://www.ansikte.se/ARAGORN/Downloads/aragorn.1";
    hash = "sha256-bjD22dpkQZcGR0TwMxdpaed4VZZO2NUOoAw4o66iyS4=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.41";
  pname = "aragorn";

  src = fetchurl {
    url = "http://www.ansikte.se/ARAGORN/Downloads/aragorn${finalAttrs.version}.c";
    hash = "sha256-kqMcxcCwrRbU17AZkZibd18H0oFd8TX+bj6riPXpf0o=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  buildPhase = ''
    runHook preBuild

    $CC -O3 -ffast-math -finline-functions -o aragorn $src

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin && cp aragorn $out/bin
    installManPage ${man}

    runHook postInstall
=======
{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.2.38";
  pname = "aragorn";

  src = fetchurl {
    url = "http://mbio-serv2.mbioekol.lu.se/ARAGORN/Downloads/${pname}${version}.tgz";
    sha256 = "09i1rg716smlbnixfm7q1ml2mfpaa2fpn3hwjg625ysmfwwy712b";
  };

  buildPhase = ''
    $CC -O3 -ffast-math -finline-functions -o aragorn aragorn${version}.c
  '';

  installPhase = ''
    mkdir -p $out/bin && cp aragorn $out/bin
    mkdir -p $out/man/1 && cp aragorn.1 $out/man/1
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Detects tRNA, mtRNA, and tmRNA genes in nucleotide sequences";
<<<<<<< HEAD
    homepage = "http://www.ansikte.se/ARAGORN/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
})
=======
    homepage = "http://mbio-serv2.mbioekol.lu.se/ARAGORN/";
    license = licenses.gpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
