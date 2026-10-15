{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "iconpack-jade";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "iconpack-jade";
    rev = "v${version}";
    hash = "sha256-AHYEkQTAPyZwD8QChdAxSVVQgkJYBjt5JEiPFAsdn18=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a Jade* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = {
    description = "Icon pack based upon Faenza and Mint-X";
    homepage = "https://github.com/madmaxms/iconpack-jade";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
