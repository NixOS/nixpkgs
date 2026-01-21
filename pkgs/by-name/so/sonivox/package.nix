{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "sonivox";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "EmbeddedSynth";
    repo = "sonivox";
    tag = "v${version}";
    hash = "sha256-eOC/7R45X93Q9KKnP+/fyPMESOVyTnzpqnLHnDQwLnQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/EmbeddedSynth/sonivox";
    description = "MIDI synthesizer library";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.wegank ];
    platforms = lib.platforms.all;
  };
}
