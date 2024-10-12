{ lib, stdenv, fetchFromGitHub, pkg-config, lv2 }:

stdenv.mkDerivation rec {
  pname = "x42-mtc";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "mtc.lv2";
    rev = "v${version}";
    sha256 = "sha256-LTHLlpANr+KNxMRejPgNP4BpVLEEFUQmZBVNVPBhWdQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lv2 ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "MIDI Timecode Generator lv2 plugin by Robin Gareus.";
    homepage = "https://x42-plugins.com/x42/x42-midi-timecode-generator";
    maintainers = with maintainers; [ PowerUser64 ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
