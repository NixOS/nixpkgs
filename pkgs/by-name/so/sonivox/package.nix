{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonivox";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "EmbeddedSynth";
    repo = "sonivox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ybGHlgI/1uyFNzSiIC4l7FQ6gVJw35NrdpooygnnQo=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/EmbeddedSynth/sonivox";
    description = "MIDI synthesizer library";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.wegank ];
    platforms = lib.platforms.all;
  };
})
