{
  lib,
  buildSddmThemePackage,
  fetchFromGitHub,
  installFonts,
  kdePackages,
  nix-update-script,
  embeddedTheme ? "astronaut",

  # deprecated in favor of `.withConfig`
  themeConfig ? null,
}:
buildSddmThemePackage {
  pname = "sddm-astronaut";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "abb3163c724935af888ba5ea9ac0c4f22afd8048";
    hash = "sha256-BujSjoQlMH6PZIfn3Ox7hp6JFb2aRGtALOnpAGqqyNE=";
  };

  nativeBuildInputs = [ installFonts ];

  sddmBuildInputs = with kdePackages; [
    qtmultimedia
    qtvirtualkeyboard
  ];

  configPath = "Themes/${embeddedTheme}.conf";
  configOverrides =
    lib.warnIf (themeConfig != null)
      "sddm-astronaut: `themeConfig` is deprecated, use `sddm-astronaut.withConfig { ... }` instead"
      (if themeConfig != null then themeConfig else { });

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Modern looking qt6 sddm theme";
    homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      danid3v
      uxodb
      qweered
    ];
  };
}
