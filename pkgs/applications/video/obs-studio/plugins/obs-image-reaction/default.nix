{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-image-reaction";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "scaledteam";
    repo = "obs-image-reaction";
    tag = finalAttrs.version;
    sha256 = "sha256-mC1B8tveHx35pfbAcOlosB8YKaBVg87MjXbr79sf7+k=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  meta = {
    description = "OBS Studio plugin for adding an image that reacts to a sound source";
    homepage = "https://github.com/scaledteam/obs-image-reaction";
    license = with lib.licenses; [
      gpl2
    ];
    maintainers = [ lib.maintainers.codebam ];
    inherit (obs-studio.meta) platforms;
  };
})
