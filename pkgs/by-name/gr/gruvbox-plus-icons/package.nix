{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  kdePackages,
  hicolor-icon-theme,
  nix-update-script,
  folder-color ? "plasma", # Supported colors: black blue caramel citron firebrick gold green grey highland jade lavender lime olive orange pistachio plasma pumpkin purple red rust sapphire tomato violet white yellow
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gruvbox-plus-icons";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = "gruvbox-plus-icon-pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t4bQeK9jwaE3nRZEhks9QARKkxKdH9ZTSgPIby323Jc=";
  };

  patches = [ ./folder-color.patch ];

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    kdePackages.breeze-icons
    hicolor-icon-theme
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r Gruvbox-Plus-Dark $out/share/icons/
    cp -r Gruvbox-Plus-Light $out/share/icons/
    patchShebangs scripts/folders-color-chooser
    ./scripts/folders-color-chooser -c ${folder-color}
    gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Dark
    gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Light

    runHook postInstall
  '';

  dontDropIconThemeCache = true;
  dontBuild = true;
  dontConfigure = true;
  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Icon pack for Linux desktops based on the Gruvbox color scheme";
    homepage = "https://github.com/SylEleuth/gruvbox-plus-icon-pack";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      eureka-cpu
      Gliczy
    ];
  };
})
