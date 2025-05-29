{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-dvd-screensaver";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "wimpysworld";
    repo = "obs-dvd-screensaver";
    tag = "${finalAttrs.version}";
    hash = "sha256-uZdFP3TULECzYNKtwaxFIcFYeFYdEoJ+ZKAqh9y9MEo=";
  };
  strictDeps = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  meta = {
    description = "DVD screen saver for OBS Studio";
    homepage = "https://github.com/wimpysworld/obs-dvd-screensaver";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
