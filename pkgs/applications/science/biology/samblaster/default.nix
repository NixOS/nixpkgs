{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "samblaster";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "GregoryFaust";
    repo = "samblaster";
    rev = "v.${version}";
    sha256 = "0iv2ddfw8363vb2x8gr3p8g88whb6mb9m0pf71i2cqsbv6jghap7";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp samblaster $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Tool for marking duplicates and extracting discordant/split reads from SAM/BAM files";
    maintainers = with maintainers; [ jbedo ];
    license = licenses.mit;
    homepage = "https://github.com/GregoryFaust/samblaster";
    platforms = platforms.x86_64;
  };
}
