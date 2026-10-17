{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  kdePackages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gruvbox-dark-icons-gtk";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "gruvbox-dark-icons-gtk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4ovfRCls8ttJX2fMnU5ZWc/HuC5W4YfsX16YlXMWero=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    kdePackages.breeze-icons
    hicolor-icon-theme
  ];

  installPhase = ''
    mkdir -p $out/share/icons/oomox-gruvbox-dark
    rm README.md
    cp -r * $out/share/icons/oomox-gruvbox-dark
    gtk-update-icon-cache $out/share/icons/oomox-gruvbox-dark
  '';

  dontDropIconThemeCache = true;
  dontWrapQtApps = true;

  meta = {
    description = "Gruvbox icons for GTK based desktop environments";
    homepage = "https://github.com/jmattheis/gruvbox-dark-gtk";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nomisiv ];
  };
})
