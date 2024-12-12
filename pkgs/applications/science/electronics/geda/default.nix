{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  groff,
  pkg-config,
  guile,
  gtk2,
  flex,
  gawk,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "geda";
  version = "1.10.2";

  src = fetchurl {
    url = "http://ftp.geda-project.org/geda-gaf/stable/v${lib.versions.majorMinor version}/${version}/geda-gaf-${version}.tar.gz";
    hash = "sha256-6GKrJBUoU4+jvuJzkmH1aAERArYMXjmi8DWGY8BCyKQ=";
  };

  patches = [
    (fetchpatch {
      name = "geda-1.10.2-drop-xorn.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-electronics/geda/files/geda-1.10.2-drop-xorn.patch?id=5589cc7bc6c4f18f75c40725a550b8d76e7f5ca1";
      hash = "sha256-jPQaHjEDwCEfZqDGku+xyIMl5WlWlVcpPv1W6Xf8Grs=";
    })
  ];

  configureFlags = [
    "--disable-update-xdg-database"
    "--without-libfam"
  ];

  nativeBuildInputs = [
    autoreconfHook
    groff
    pkg-config
  ];
  buildInputs = [
    guile
    gtk2
    flex
    gawk
    perl
  ];

  meta = with lib; {
    description = "Full GPL'd suite of Electronic Design Automation tools";
    homepage = "http://www.geda-project.org/";
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
