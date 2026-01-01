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
    url = "http://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/${pname}-${version}.tar.gz";
    sha256 = "0hj0m9xygiqsdxvbg79wq579kbrx1mdrabi2bzqz2zn9qwfjcjgq";
  };

  doCheck = true;

  buildInputs = [ glib ];

  nativeBuildInputs = [ pkg-config ];

<<<<<<< HEAD
  meta = {
    description = "Generic tool for sequence alignment";
    homepage = "https://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Generic tool for sequence alignment";
    homepage = "https://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate";
    license = licenses.gpl3;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
