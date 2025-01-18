{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "gpx";
  version = "2.6.8";

  nativeBuildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "markwal";
    repo = "GPX";
    rev = version;
    sha256 = "1izs8s5npkbfrsyk17429hyl1vyrbj9dp6vmdlbb2vh6mfgl54h8";
  };

  meta = with lib; {
    description = "Gcode to x3g conversion postprocessor";
    homepage = "https://github.com/markwal/GPX/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.leo60228 ];
  };
}
