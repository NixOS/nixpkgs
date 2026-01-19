{
  lib,
  stdenv,
  fetchFromGitHub,
  udevCheckHook,
}:

## Usage
# In NixOS, set hardware.keyboard.qmk.enable = true;

stdenv.mkDerivation rec {
  pname = "qmk-udev-rules";
  version = "0.27.13";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_firmware";
    tag = version;
    hash = "sha256-Zs508OQ0RYCg0f9wqR+VXUmVvhP/jCA3piwRq2ZpR84=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    install -D util/udev/50-qmk.rules $out/lib/udev/rules.d/50-qmk.rules

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/qmk/qmk_firmware";
    description = "Official QMK udev rules list";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
}
