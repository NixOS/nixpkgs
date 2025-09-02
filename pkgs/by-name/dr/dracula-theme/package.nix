{
  lib,
  stdenvNoCC,
  buildSddmThemePackage,
  fetchFromGitHub,
  unstableGitUpdater,
  gtk-engine-murrine,
  libsForQt5,
}:
let
  themeName = "Dracula";
  version = "4.0.0-unstable-2025-08-04";

  base = {
    pname = "dracula-theme";
    inherit version;

    src = fetchFromGitHub {
      owner = "dracula";
      repo = "gtk";
      rev = "3834a1bac175b226cff6b1c94faac9aba2819bd5";
      hash = "sha256-8p9IS5aMZGP/VCuFTjQU+D3wfFIwfT/lcY7ujUv3SRc=";
    };

    meta = {
      homepage = "https://github.com/dracula/gtk";
      license = lib.licenses.gpl3;

      maintainers = with lib.maintainers; [ alexarice ];
    };
  };

  sddmTheme = buildSddmThemePackage {
    pname = "${base.pname}-sddm";
    inherit (base) version src;

    qtVersion = "qt5";
    sddmBuildInputs = with libsForQt5; [
      plasma-framework
      # plasma-workspace # TODO (only for qt6)

      qtquickcontrols
      qtgraphicaleffects
    ];

    inherit themeName;
    srcThemeDir = "kde/sddm/Dracula";
    configPath = "theme.conf";

    meta = base.meta // {
      description = "Dracula variant of the Ant SDDM theme";

      platforms = lib.platforms.linux;
      broken = true;
    };
  };
in
stdenvNoCC.mkDerivation {
  inherit (base) pname version src;

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/${themeName}
    cp -a {assets,cinnamon,gnome-shell,gtk-2.0,gtk-3.0,gtk-3.20,gtk-4.0,index.theme,metacity-1,unity,xfwm4} $out/share/themes/${themeName}

    cp -a kde/{color-schemes,plasma} $out/share/
    cp -a kde/kvantum $out/share/Kvantum
    mkdir -p $out/share/aurorae/themes
    cp -a kde/aurorae/* $out/share/aurorae/themes/

    mkdir -p $out/share/icons/Dracula-cursors
    mv kde/cursors/Dracula-cursors/index.theme $out/share/icons/Dracula-cursors/cursor.theme
    mv kde/cursors/Dracula-cursors/cursors $out/share/icons/Dracula-cursors/cursors

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };

    sddm = sddmTheme;
  };

  meta = base.meta // {
    description = "Dracula variant of the Ant theme";
    platforms = lib.platforms.all;
  };
}
