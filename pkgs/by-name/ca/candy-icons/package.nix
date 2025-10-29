{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "candy-icons";
  version = "0-unstable-2025-09-09";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "40cbbc8821db020e2668c309cd5a7bbfabd0be06";
    hash = "sha256-wJ86TUjiVYT64QunDk85Jji5vo0Os+D9t/fsyKRM+P0=";
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

  passthru.updateScript = unstableGitUpdater { };

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
