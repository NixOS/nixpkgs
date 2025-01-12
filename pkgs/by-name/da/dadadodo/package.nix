{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dadadodo";
  version = "1.04";

  src = fetchurl {
    url = "https://www.jwz.org/dadadodo/${pname}-${version}.tar.gz";
    sha256 = "1pzwp3mim58afjrc92yx65mmgr1c834s1v6z4f4gyihwjn8bn3if";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    mkdir -p $out/bin
    cp dadadodo $out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Markov chain-based text generator";
    mainProgram = "dadadodo";
    homepage = "http://www.jwz.org/dadadodo";
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.all;
  };
}
