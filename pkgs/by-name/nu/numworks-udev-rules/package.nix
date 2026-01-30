{
  lib,
  stdenv,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "numworks-udev-rules";
  version = "unstable-2020-08-31";

  udevRules = ./50-numworks-calculator.rules;
  dontUnpack = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    install -Dm 644 "${udevRules}" "$out/lib/udev/rules.d/50-numworks-calculator.rules"
  '';

  meta = {
    description = "Udev rules for Numworks calculators";
    homepage = "https://numworks.com";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
