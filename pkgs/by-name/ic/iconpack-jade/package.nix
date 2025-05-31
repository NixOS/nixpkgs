{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  gnome-icon-theme,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "iconpack-jade";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "iconpack-jade";
    rev = "v${version}";
    sha256 = "0pwz3l5i93s84iwkn1jq8a150ma96788a0n41xq2cgy00j8h8xh0";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    gnome-icon-theme
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

  meta = with lib; {
    description = "Icon pack based upon Faenza and Mint-X";
    homepage = "https://github.com/madmaxms/iconpack-jade";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
