{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name    = "bwa-${version}";
  version = "0.7.16a";

  src = fetchurl {
    url = "mirror://sourceforge/bio-bwa/${name}.tar.bz2";
    sha256 = "0w61zxh6b4isydw5qp6pdb1mc50jg1h8vhahw2xm24w7i1gxpv4g";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    install -vD bwa $out/bin/bwa
  '';

  meta = with stdenv.lib; {
    description = "A software package for mapping low-divergent sequences against a large reference genome, such as the human genome";
    license     = licenses.gpl3;
    homepage    = http://bio-bwa.sourceforge.net/;
    maintainers = with maintainers; [ luispedro ];
    platforms = [ "x86_64-linux" ];
  };
}
