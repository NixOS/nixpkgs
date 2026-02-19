{
  lib,
  stdenv,
  udevCheckHook,
}:

stdenv.mkDerivation {
  pname = "bequiet-udev-rules";
  version = "0-unstable-2026-07-21";

  __structuredAttrs = true;

  doInstallCheck = true;

  dontUnpack = true;

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/70-bequiet.rules
  '';

  meta = {
    homepage = "https://iocenter.bequiet.com";
    description = "udev rules that give logged in users permissions to administer bequiet peripherals";
    platforms = lib.platforms.linux;
    # We think they are so simple that they are uncopyrightable
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [
      niels
    ];
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  # Source: https://iocenter.bequiet.com/update-udev.sh
  src = [ ./bequiet.rules ];

  strictDeps = true;
}
