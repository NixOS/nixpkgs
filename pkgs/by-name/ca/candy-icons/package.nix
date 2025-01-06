{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "candy-icons";
  version = "0-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "f8a4125d338d86a58723ab36f9f827248d07c85c";
    hash = "sha256-Bv91a5NglKWwddqx0kPgdCrik9SOPtcfQFJDWOdcQG4=";
  };

  nativeBuildInputs = [ gtk3 ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/candy-icons
    cp -r . $out/share/icons/candy-icons
    gtk-update-icon-cache $out/share/icons/candy-icons

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/EliverLara/candy-icons";
    description = "Icon theme colored with sweet gradients";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      clr-cera
      arunoruto
    ];
  };
}
