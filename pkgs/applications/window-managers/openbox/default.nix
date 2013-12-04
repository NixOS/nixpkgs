{ stdenv, fetchurl, pkgconfig
, libxml2, libXinerama, libXcursor, libXau, libXrandr
, imlib2, pango, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "openbox-3.5.2";

  buildInputs = [
    pkgconfig libxml2
    libXinerama libXcursor libXau libXrandr
    imlib2 pango libstartup_notification
  ];

  src = fetchurl {
    url = "http://openbox.org/dist/openbox/${name}.tar.gz";
    sha256 = "0cxgb334zj6aszwiki9g10i56sm18i7w1kw52vdnwgzq27pv93qj";
  };

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = http://openbox.org/;
    license = "GPLv2+";
  };
}
