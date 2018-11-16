{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "gpx-${version}";
  version = "2.5.2";

  nativeBuildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "markwal";
    repo = "GPX";
    rev = version;
    sha256 = "1yab269x8qyf7rd04vaxyqyjv4pzz9lp4sc4dwh927k23avr3rw5";
  };

  meta = {
    description = "Gcode to x3g conversion postprocessor";
    homepage = https://github.com/markwal/GPX/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.leo60228 ];
  };
}
