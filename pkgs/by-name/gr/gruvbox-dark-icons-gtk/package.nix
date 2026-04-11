{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  gnome-icon-theme,
  hicolor-icon-theme,
  libsForQt5,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gruvbox-dark-icons-gtk";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "gruvbox-dark-icons-gtk";
    rev = "v${finalAttrs.version}";
    sha256 = "1fks2rrrb62ybzn8gqan5swcgksrb579vk37bx4xpwkc552dz2z2";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    libsForQt5.breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
  ];

  installPhase = ''
    mkdir -p $out/share/icons/oomox-gruvbox-dark
    rm README.md
    cp -r * $out/share/icons/oomox-gruvbox-dark
    gtk-update-icon-cache $out/share/icons/oomox-gruvbox-dark
  '';

  dontDropIconThemeCache = true;

  meta = {
    description = "Gruvbox icons for GTK based desktop environments";
    homepage = "https://github.com/jmattheis/gruvbox-dark-gtk";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nomisiv ];
  };
})
