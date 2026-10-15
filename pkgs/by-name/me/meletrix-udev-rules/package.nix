{
  lib,
  stdenvNoCC,
  udevCheckHook,
}:
stdenvNoCC.mkDerivation {
  pname = "meletrix-udev-rules";
  version = "0-unstable-2023-10-20";

  src = [ ./meletrix.rules ];

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/70-meletrix.rules
  '';

  meta = {
    description = "udev rules to configure Meletrix keyboards";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = lib.platforms.linux;
  };
}
