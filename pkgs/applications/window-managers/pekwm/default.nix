{ stdenv, fetchurl, pkgconfig
, libpng, libjpeg
, libXext, libXft, libXpm, libXrandr, libXinerama }:

stdenv.mkDerivation rec {

  pname = "pekwm";
  version = "0.1.17";

  src = fetchurl {
    url = "https://www.pekwm.org/projects/pekwm/files/${pname}-${version}.tar.bz2";
    sha256 = "003x6bxj1lb2ljxz3v414bn0rdl6z68c0r185fxwgs1qkyzx67wa";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng libjpeg
  libXext libXft libXpm libXrandr libXinerama ];

  meta = with stdenv.lib; {
    description = "A lightweight window manager";
    longDescription = ''
      pekwm is a window manager that once upon a time was based on the
      aewm++ window manager, but it has evolved enough that it no
      longer resembles aewm++ at all. It has a much expanded
      feature-set, including window grouping (similar to ion, pwm, or
      fluxbox), autoproperties, xinerama, keygrabber that supports
      keychains, and much more.      
      - Lightweight and Unobtrusive, a window manager shouldn't be
        noticed.
      - Very configurable, we all work and think in different ways.
      - Automatic properties, for all the lazy people, make things
        appear as they should when starting applications.
      - Chainable Keygrabber, usability for everyone.
    '';
      homepage = http://www.pekwm.org;
      license = licenses.gpl2;
      maintainers = [ maintainers.AndersonTorres ];
      platforms = platforms.linux;
  };
}
