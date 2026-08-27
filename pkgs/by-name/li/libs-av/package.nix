{
  clangStdenv,
  fetchFromGitHub,
  fetchpatch,
  gnustep-make,
  gnustep-back,
  gnustep-base,
  lib,
  withGershwinPatches ? false,
  wrapGNUstepAppsHook,
}:

clangStdenv.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "libs-av";
  version = "0-unstable-2026-07-27";

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "libs-av";
    rev = "26566e25043ffc354364a9a5ff2c69252f81d404";
    hash = "sha256-vy8zhSxsZ+G/sCPu0yTtLLb+lgbLPMW3xXq7sXFhyRo=";
  };

  nativeBuildInputs = [
    wrapGNUstepAppsHook
    gnustep-make
    gnustep-base
  ];

  buildInputs = [
    gnustep-back
  ];

  patches = lib.optionals withGershwinPatches [
    (fetchpatch {
      name = "metadata.patch";
      url = "https://raw.githubusercontent.com/gershwin-desktop/gershwin-developer/81bd1c3269819bc889701ec3674b7def892db5be/Library/Patches/libs-av-metadata.patch";
      sha256 = "sha256-SUEJGQGy/eSNzuWgX+uEwBMn5GvfzWJZA1XhW7xjkh8=";
    })
  ];

  meta = {
    homepage = "https://github.com/gnustep/libs-av";
    description = "A GNUstep implementation of the AVFoundation library, based on FFmpeg";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
  };
  platforms = lib.platforms.linux;
})
