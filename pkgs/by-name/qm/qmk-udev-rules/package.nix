{
  lib,
  stdenv,
  fetchFromGitHub,
  udevCheckHook,
}:

## Usage
# In NixOS, set hardware.keyboard.qmk.enable = true;

stdenv.mkDerivation (finalAttrs: {
  pname = "qmk-udev-rules";
  version = "0.1.20";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_udev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sxwvyMniEXTnmHEs8ldsBjwReKUT5FlqYxcUULV0cpI=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/qmk/qmk_udev";
    description = "Official QMK udev rules and udev helper program";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      telometto
    ];
  };
})
