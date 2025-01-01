{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "shared-desktop-ontologies";
  version = "0.11.0";

  src = fetchurl {
    url = "mirror://sourceforge/oscaf/shared-desktop-ontologies-${version}.tar.bz2";
    sha256 = "1m5vnijg7rnwg41vig2ckg632dlczzdab1gsq51g4x7m9k1fdbw2";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://oscaf.sourceforge.net/";
    description = "Ontologies necessary for the Nepomuk semantic desktop";
    longDescription = ''
      The shared-desktop-ontologies package brings the semantic web to the
      desktop in terms of vocabulary. It contains the well known core
      ontologies such as RDF and RDFS as well as the Nepomuk ontologies which
      are used by projects like KDE or Strigi.
    '';
    platforms = platforms.all;
    maintainers = [ maintainers.sander ];
  };
}
