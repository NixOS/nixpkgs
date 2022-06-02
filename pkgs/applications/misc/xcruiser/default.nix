{ lib, stdenv, fetchurl, gccmakedep, imake, libXt, libXaw, libXpm, libXext }:

stdenv.mkDerivation rec {
  pname = "xcruiser";
  version = "0.30";

  src = fetchurl {
    url = "mirror://sourceforge/xcruiser/xcruiser/xcruiser-${version}/xcruiser-${version}.tar.gz";
    sha256 = "1r8whva38xizqdh7jmn6wcmfmsndc67pkw22wzfzr6rq0vf6hywi";
  };

  nativeBuildInputs = [ gccmakedep imake ];
  buildInputs = [ libXt libXaw libXpm libXext ];

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "CONFDIR=${placeholder "out"}/etc/X11"
    "LIBDIR=${placeholder "out"}/lib/X11"
    "XAPPLOADDIR=${placeholder "out"}/etc/X11/app-defaults"
  ];

  meta = with lib; {
    description = "Filesystem visualization utility";
    longDescription = ''
      XCruiser, formerly known as XCruise, is a filesystem visualization utility.
      It constructs a virtually 3-D formed universe from a directory
      tree and allows you to "cruise" within a visualized filesystem.
    '';
    homepage = "http://xcruiser.sourceforge.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; linux;
  };
}
