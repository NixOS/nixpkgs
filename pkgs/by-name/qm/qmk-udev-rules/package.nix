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

  dontBuild = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    install -D 50-qmk.rules $out/lib/udev/rules.d/50-qmk.rules

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/qmk/qmk_firmware";
    description = "Official QMK udev rules list";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
})
