{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  gtk3,
  gnome-icon-theme,
  hicolor-icon-theme,
  mint-x-icons,
  pantheon,
  jdupes,
  libsForQt5,
}:

stdenvNoCC.mkDerivation {
  pname = "BeautyLine";
  version = "2.4";

  src = fetchFromGitLab {
    owner = "garuda-linux";
    repo = "themes-and-settings/artwork/beautyline";
    rev = "0df6f5df71c19496f9a873f8a52fbb5e84e95b12";
    hash = "sha256-SsYW4H1qam7kQJ3E4/vHJJOv2E4Pdk3itGncWa6YTqw=";
  };

  nativeBuildInputs = [
    jdupes
    gtk3
  ];

  # ubuntu-mono is also required but missing in ubuntu-themes (please add it if it is packaged at some point)
  propagatedBuildInputs = [
    libsForQt5.breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
    mint-x-icons
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/BeautyLine
    cp -r * $out/share/icons/BeautyLine/
    gtk-update-icon-cache $out/share/icons/BeautyLine

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = {
    description = "BeautyLine icon theme";
    homepage = "https://www.gnome-look.org/p/1425426/";
    platforms = lib.platforms.linux;
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ lwb-2021 ];
  };
}
