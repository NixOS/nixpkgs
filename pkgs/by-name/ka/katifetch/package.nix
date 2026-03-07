{ stdenv, fetchzip }:

stdenv.mkDerivation {
  pname = "katifetch";
  version = "13.1";

  src = fetchzip {
    url = "https://github.com/ximimoments/katifetch/archive/refs/tags/13.1.zip";
    sha256 = "1y4arp28807z28k9p69qsm0afn71cbwrpx2s3a9g7bxcpqbrnkzy";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp katifetch.sh $out/bin/katifetch
    chmod +x $out/bin/katifetch
  '';

  meta = {
    description = "Fast and customizable Neofetch alternative written in Bash";
    homepage = "https://github.com/ximimoments/katifetch";
  };
}
