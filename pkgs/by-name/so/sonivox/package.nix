{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonivox";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "EmbeddedSynth";
    repo = "sonivox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FExMOhE2iz/FDCldryG1eqxJF/JvYHczyrQ8r0OL6Es=";
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
