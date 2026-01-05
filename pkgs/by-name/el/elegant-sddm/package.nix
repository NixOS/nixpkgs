{
  lib,
  formats,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,

  # Override themeConfig.General.background for custom backgrounds
  # https://wiki.nixos.org/wiki/SDDM_Themes
  themeConfig ? null,
}:

let
  user-cfg = (formats.ini { }).generate "theme.conf.user" themeConfig;
in

stdenvNoCC.mkDerivation {
  pname = "elegant-sddm";
  version = "0-unstable-2024-03-30";

  src = fetchFromGitHub {
    owner = "rainD4X";
    repo = "Elegant-sddm-qt6";
    rev = "66952cbe32460938c0b6e8c6cf3343047af098f0";
    hash = "sha256-l4gv1PEVWpLmzNt1c+dHTHtM5WlEsXdDgW3q8U3FMUQ=";
  };

  dontWrapQtApps = true;
  propagatedBuildInputs = [
    kdePackages.qt5compat
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes"
    cp -r Elegant/ "$out/share/sddm/themes/Elegant"
  ''
  + (lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/Elegant/theme.conf.user
  '')
  + ''
    runHook postInstall
  '';

  meta = {
    description = "Sleek and stylish SDDM theme crafted in QML for Qt6";
    homepage = "https://github.com/rainD4X/Elegant-sddm-qt6";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      redlonghead
    ];
  };
}
