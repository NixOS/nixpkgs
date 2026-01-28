{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-applet-resources-monitor";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "orblazer";
    repo = "plasma-applet-resources-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-du38PM5kLiBWwEvli8mfUGTfMGqdS86CkMttTepMhFk=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.libplasma
    kdePackages.libksysguard
    kdePackages.kdeplasma-addons
  ];

  meta = {
    description = "Resources monitor - Plasma 6 widget";
    longDescription = ''
      Plasmoid for monitoring CPU, memory, network traffic, GPUs and disks IO.
    '';
    license = lib.licenses.gpl3Only; # TODO: gpl3Plus established in e60aa0168c39d8470631714924ccce653f8a75c2
    homepage = "https://github.com/orblazer/plasma-applet-resources-monitor/";
    maintainers = with lib.maintainers; [ EntranceJew ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
