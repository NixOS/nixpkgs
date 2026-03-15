{ stdenv, fetchFromGitHub, bash, pciutils, coreutils, lib }:

stdenv.mkDerivation {
  pname = "katifetch";
  version = "13.1";

  src = fetchFromGitHub {
    owner = "ximimoments";
    repo = "katifetch";
    rev = "13.1";
    sha256 = "1y4arp28807z28k9p69qsm0afn71cbwrpx2s3a9g7bxcpqbrnkzy";
  };

  buildInputs = [ coreutils ];
  propagatedBuildInputs = [ bash pciutils ];

  installPhase = ''
    mkdir -p $out/bin
    cp katifetch.sh $out/bin/katifetch
    chmod +x $out/bin/katifetch
  '';

 meta = {
  description = "Fast and customizable Neofetch alternative written in Bash";
  homepage = "https://github.com/ximimoments/katifetch";
  license = lib.licenses.mit;
  platforms = lib.platforms.all;
  maintainers = [];
 };
}
