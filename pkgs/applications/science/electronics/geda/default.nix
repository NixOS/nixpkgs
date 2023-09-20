{ lib, stdenv, fetchurl, groff, pkg-config, python2, guile, gtk2, flex, gawk, perl }:

stdenv.mkDerivation rec {
  pname = "geda";
  version = "1.10.2";

  src = fetchurl {
    url = "http://ftp.geda-project.org/geda-gaf/stable/v${lib.versions.majorMinor version}/${version}/geda-gaf-${version}.tar.gz";
    hash = "sha256-6GKrJBUoU4+jvuJzkmH1aAERArYMXjmi8DWGY8BCyKQ=";
  };

  configureFlags = [
    "--disable-update-xdg-database"
    "--without-libfam"
  ];

  nativeBuildInputs = [ groff pkg-config python2 ];
  buildInputs = [ guile gtk2 flex gawk perl ];

  meta = with lib; {
    description = "Full GPL'd suite of Electronic Design Automation tools";
    homepage = "http://www.geda-project.org/";
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
