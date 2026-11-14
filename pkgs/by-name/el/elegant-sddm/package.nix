{
  lib,
  buildSddmThemePackage,
  fetchFromGitHub,
  kdePackages,

  # deprecated in favor of `.withConfig`
  themeConfig ? null,
}:

buildSddmThemePackage {
  pname = "elegant-sddm";
  version = "0-unstable-2024-03-30";

  src = fetchFromGitHub {
    owner = "rainD4X";
    repo = "Elegant-sddm-qt6";
    rev = "66952cbe32460938c0b6e8c6cf3343047af098f0";
    hash = "sha256-l4gv1PEVWpLmzNt1c+dHTHtM5WlEsXdDgW3q8U3FMUQ=";
  };

  sddmBuildInputs = with kdePackages; [
    qt5compat
  ];

  srcThemeDir = "Elegant";

  configPath = "theme.conf";
  configOverrides =
    lib.warnIf (themeConfig != null)
      "elegant-sddm: `themeConfig` is deprecated, use `elegant-sddm.withConfig { ... }` instead"
      (themeConfig.General or { });

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
