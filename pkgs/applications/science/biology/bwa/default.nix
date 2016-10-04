{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  name    = "bwa-${version}";
  version = "0.7.15";

  src = fetchFromGitHub {
    owner  = "lh3";
    repo   = "bwa";
    rev    = "v${version}";
    sha256 = "1aasdr3lik42gafi9lds7xw0wgv8ijjll1g32d7jm04pp235c7nl";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp bwa $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A software package for mapping low-divergent sequences against a large reference genome, such as the human genome";
    license     = licenses.gpl3;
    homepage    = http://bio-bwa.sourceforge.net/;
    maintainers = with maintainers; [ luispedro ];
    platforms = [ "x86_64-linux" ];
  };
}
