{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpx";
  version = "2.6.8";

  nativeBuildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "markwal";
    repo = "GPX";
    rev = finalAttrs.version;
    hash = "sha256-CJJCn6sGbrEWbXWb25Jc2e9APUyCnDC9zm7Na4tG+sc=";
  };

  meta = {
    description = "Gcode to x3g conversion postprocessor";
    homepage = "https://github.com/markwal/GPX/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.leo60228 ];
  };
})
