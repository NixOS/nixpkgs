{ lib
, stdenv
, fetchFromGitHub
, awk
, grep
, sed
, runtimeShell
, cmake
, libXext
, libXft
, libXinerama
, libXpm
, libXrandr
, libjpeg
, libpng
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "pekwm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "pekdon";
    repo = "pekwm";
    rev = "release-${version}";
    hash= "sha256-hA+TBAs9NMcc5DKIkzyUHWck3Xht+yeCO54xJ6oXXuQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DAWK=${awk}/bin/awk"
    "-DGREP=${grep}/bin/grep"
    "-DSED=${sed}/bin/sed"
    "-DSH=${runtimeShell}"
  ];

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
    homepage = "https://www.pekwm.se/";
    description = "A lightweight window manager";
    longDescription = ''
      pekwm is a window manager that once upon a time was based on the aewm++
      window manager, but it has evolved enough that it no longer resembles
      aewm++ at all. It has a much expanded feature-set, including window
      grouping (similar to ion, pwm, or fluxbox), autoproperties, xinerama,
      keygrabber that supports keychains, and much more.

      - Lightweight and Unobtrusive, a window manager shouldn't be noticed.
      - Very configurable, we all work and think in different ways.
      - Automatic properties, for all the lazy people, make things appear as
        they should when starting applications.
      - Chainable Keygrabber, usability for everyone.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
