{ stdenv, fetchurl, pkgconfig
, libxml2, libXinerama, libXcursor, libXau, libXrandr
, imlib2, pango, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "openbox-3.5.0";

  buildInputs = [
    pkgconfig libxml2
    libXinerama libXcursor libXau libXrandr
    imlib2 pango libstartup_notification
  ];

  src = fetchurl {
    url = "http://openbox.org/dist/openbox/${name}.tar.gz";
    sha256 = "02pa1wa2rzvnq1z3xchzafc96hvp3537jh155q8acfhbacb01abg";
  };

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = http://openbox.org/;
    license = "GPLv2+";
  };
}
