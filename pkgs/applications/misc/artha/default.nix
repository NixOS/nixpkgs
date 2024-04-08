{ lib, stdenv, autoreconfHook, fetchurl, dbus-glib, gtk2, pkg-config, wordnet }:

stdenv.mkDerivation rec {
  pname = "artha";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/artha/${version}/artha-${version}.tar.bz2";
    sha256 = "034r7vfk5y7705k068cdlq52ikp6ip10w6047a5zjdakbn55c3as";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ dbus-glib gtk2 wordnet ];

  meta = with lib; {
    description = "An offline thesaurus based on WordNet";
    homepage = "https://artha.sourceforge.net";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
    mainProgram = "artha";
  };
}
