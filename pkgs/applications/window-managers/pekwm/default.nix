{ lib, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, libXext
, libXft
, libXinerama
, libXpm
, libXrandr
, libjpeg
, libpng
}:

stdenv.mkDerivation rec {
  pname = "pekwm";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "pekdon";
    repo = "pekwm";
    rev = "release-${version}";
    sha256 = "sha256-R1XDEk097ycMI3R4SjUEJv37CiMaDCQMvg7N8haN0MM=";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    libXext
    libXft
    libXinerama
    libXpm
    libXrandr
    libjpeg
    libpng
  ];

  meta = with lib; {
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
      homepage = "http://www.pekwm.org";
      license = licenses.gpl2Plus;
      maintainers = [ maintainers.AndersonTorres ];
      platforms = platforms.linux;
  };
}
