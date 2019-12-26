{ stdenv, fetchurl, sane-backends, libX11, gtk2, pkgconfig, libusb ? null }:

stdenv.mkDerivation rec {
  pname = "sane-frontends";
  version = "1.0.14";

  src = fetchurl {
    url = "https://alioth-archive.debian.org/releases/sane/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "1ad4zr7rcxpda8yzvfkq1rfjgx9nl6lan5a628wvpdbh3fn9v0z7";
  };

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/gtkglue.c
  '';

  buildInputs = [ sane-backends libX11 gtk2 ]
    ++ stdenv.lib.optional (libusb != null) libusb;
  nativeBuildInputs = [ pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Scanner Access Now Easy";
    homepage    = http://www.sane-project.org/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti ];
    platforms   = platforms.linux;
  };
}
