{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "ht-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/hte/ht-source/ht-${version}.tar.bz2";
    sha256 = "0w2xnw3z9ws9qrdpb80q55h6ynhh3aziixcfn45x91bzrbifix9i";
  };

  buildInputs = [
    ncurses
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "File editor/viewer/analyzer for executables";
    homepage = "http://hte.sourceforge.net";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
