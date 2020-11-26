{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gpx";
  version = "2.6.7";

  nativeBuildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "markwal";
    repo = "GPX";
    rev = version;
    sha256 = "1dl5vlsx05ipy10h18xigicb3k7m33sa9hfyd46hkpr2glx7jh4p";
  };

  meta = {
    description = "Gcode to x3g conversion postprocessor";
    homepage = "https://github.com/markwal/GPX/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.leo60228 ];
  };
}
