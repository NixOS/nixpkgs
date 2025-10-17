{
  stdenv,
  lib,
  buildEnv,
  gnome-panel,
  gnome-flashback,
  xorg,
  glib,
  wrapGAppsHook3,
  panelModulePackages ? [ ],
}:

let
  # We always want to find the built-in panel applets.
  selectedPanelModulePackages = [
    gnome-panel
    gnome-flashback
  ]
  ++ panelModulePackages;

  panelModulesEnv = buildEnv {
    name = "gnome-panel-modules-env";
    paths = selectedPanelModulePackages;
    pathsToLink = [ "/lib/gnome-panel/modules" ];
  };
in
stdenv.mkDerivation {
  pname = "${gnome-panel.pname}-with-modules";
  inherit (gnome-panel) version;

  nativeBuildInputs = [
    glib
    wrapGAppsHook3
  ];

  buildInputs =
    selectedPanelModulePackages ++ lib.forEach selectedPanelModulePackages (x: x.buildInputs or [ ]);

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  preferLocalBuild = true;
  allowSubstitutes = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ${xorg.lndir}/bin/lndir -silent ${gnome-panel} $out

    rm -r $out/lib/gnome-panel/modules
    ${xorg.lndir}/bin/lndir -silent ${panelModulesEnv} $out

    rm $out/share/applications/gnome-panel.desktop

    ln -s ${gnome-panel}/share/applications/gnome-panel.desktop \
      $out/share/applications/gnome-panel.desktop

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set NIX_GNOME_PANEL_MODULESDIR "$out/lib/gnome-panel/modules"
    )
  '';

  meta = gnome-panel.meta // {
    outputsToInstall = [ "out" ];
  };
}
