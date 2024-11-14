{ lib
, stdenv
, fetchFromGitHub
, awk
, cmake
, grep
, libXext
, libXft
, libXinerama
, libXpm
, libXrandr
, libjpeg
, libpng
, pkg-config
, runtimeShell
, sed
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pekwm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "pekdon";
    repo = "pekwm";
    rev = "release-${finalAttrs.version}";
    hash= "sha256-hA+TBAs9NMcc5DKIkzyUHWck3Xht+yeCO54xJ6oXXuQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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

  outputs = [ "out" "man" ];

  strictDeps = true;

  cmakeFlags = [
    "-DAWK=${lib.getBin awk}/bin/awk"
    "-DGREP=${lib.getBin grep}/bin/grep"
    "-DSED=${lib.getBin sed}/bin/sed"
    "-DSH=${runtimeShell}"
  ];

  meta = {
    homepage = "https://www.pekwm.se/";
    description = "Lightweight window manager";
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
    changelog = "https://raw.githubusercontent.com/pekwm/pekwm/release-${finalAttrs.version}/NEWS.md";
    license = lib.licenses.gpl2Plus;
    mainProgram = "pekwm";
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
