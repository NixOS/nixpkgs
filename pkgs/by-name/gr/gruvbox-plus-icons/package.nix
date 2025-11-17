{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  plasma5Packages,
  gnome-icon-theme,
  hicolor-icon-theme,
  nix-update-script,
  folder-color ? "plasma", # Supported colors: black blue caramel citron firebrick gold green grey highland jade lavender lime olive orange pistachio plasma pumpkin purple red rust sapphire tomato violet white yellow
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gruvbox-plus-icons";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = "gruvbox-plus-icon-pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4UJOiDdw5BxtOjLQjCpkQnUwQRs49GZTShpcElWjAU8=";
  };

  patches = [ ./folder-color.patch ];

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    plasma5Packages.breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r Gruvbox-Plus-Dark $out/share/icons/
    patchShebangs scripts/folders-color-chooser
    ./scripts/folders-color-chooser -c ${folder-color}
    gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Dark

    runHook postInstall
  '';

  dontDropIconThemeCache = true;
  dontBuild = true;
  dontConfigure = true;

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
