
{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, breeze-icons
, gnome
, hicolor-icon-theme
, gitUpdater
,
}:
stdenvNoCC.mkDerivation rec {
  pname = "candy-icons";
  version = "ada73e9c0597b86bb2b5e32524914e89d9cd2b17";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = pname;
    rev = version;
    hash = "sha256-yXjhztUWmXMD+40pw0vnUMslxPiog3ZLrSkxcJgpxsU=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    breeze-icons
    gnome.adwaita-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/candy-icons
    cp -a * $out/share/icons/candy-icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "An icon theme colored with sweet gradients";
    homepage = "https://github.com/EliverLara/candy-icons";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delliottxyz ];
  };
}
