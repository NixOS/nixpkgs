{
  lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, plasma5Packages
, gnome-icon-theme
, hicolor-icon-theme
}:

stdenvNoCC.mkDerivation {
  pname = "gruvbox-plus-icons";
  version = "unstable-2023-12-07";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = "gruvbox-plus-icon-pack";
    rev = "f3109979fe93b31ea14eb2d5c04247a895302ea0";
    sha256 = "sha256-EijTEDkPmcDcMhCuL6fOWjU9eXFUwmeOEwfGlxadb1U=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ plasma5Packages.breeze-icons gnome-icon-theme hicolor-icon-theme ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r Gruvbox-Plus-Dark $out/share/icons/
    gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Dark

    runHook postInstall
  '';

  dontDropIconThemeCache = true;
  dontBuild = true;
  dontConfigure = true;

  meta = with lib; {
    description = "Icon pack for Linux desktops based on the Gruvbox color scheme";
    homepage = "https://github.com/SylEleuth/gruvbox-plus-icon-pack";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eureka-cpu RGBCube ];
  };
}
