{
  lib,
  stdenv,
  fetchurl,
  glib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "2.4.0";
  pname = "exonerate";

  src = fetchurl {
    url = "https://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  doCheck = true;

  buildInputs = [ glib ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Generic tool for sequence alignment";
    homepage = "https://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate";
    license = licenses.gpl3;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
