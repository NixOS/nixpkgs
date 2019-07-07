{ stdenv, fetchurl, pkgconfig, guile, gtk2, flex, gawk, perl }:

stdenv.mkDerivation rec {
  name = "geda-${version}";
  version = "1.8.2-20130925";

  src = fetchurl {
    url = "http://ftp.geda-project.org/geda-gaf/stable/v1.8/1.8.2/geda-gaf-1.8.2.tar.gz";
    sha256 = "08dpa506xk4gjbbi8vnxcb640wq4ihlgmhzlssl52nhvxwx7gx5v";
  };

  configureFlags = [
    "--disable-update-xdg-database" 
  ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ guile gtk2 flex gawk perl ];

  meta = with stdenv.lib; {
    description = "Full GPL'd suite of Electronic Design Automation tools";
    homepage = http://www.geda-project.org/;
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
