{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  gettext,
  pkg-config,
  check,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcal";
  version = "4.2.0";

  src = fetchurl {
    url = "https://www.alteholz.dev/gnu/gcal-${finalAttrs.version}.tar.xz";
    hash = "sha256-2L0tdBHnglHWcGSqDxymClI7+FbuPm2J0H2FoSM0eNw=";
  };

  patches = [
    ./add-missing-include.patch
    ./fix-gnulib-link.patch
  ];

  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-implicit-function-declaration";
    # For check_gcal
    NIX_LDFLAGS = "-lm";
  };

  enableParallelBuilding = true;

  buildInputs = [ ncurses ] ++ lib.optional stdenv.hostPlatform.isDarwin gettext;

  nativeBuildInputs = [
    pkg-config
    check
  ];

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Program for calculating and printing calendars";
    longDescription = ''
      Gcal is the GNU version of the trusty old cal(1). Gcal is a
      program for calculating and printing calendars. Gcal displays
      hybrid and proleptic Julian and Gregorian calendar sheets.  It
      also displays holiday lists for many countries around the globe.
    '';
    homepage = "https://www.gnu.org/software/gcal/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "gcal";
  };
})
