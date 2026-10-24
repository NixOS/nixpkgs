{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "candy-icons";
  version = "0-unstable-2026-10-19";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "8d21022f3b77d6a3b44f9a4a1ed26d6a974c41f6";
    hash = "sha256-OIVYHhSZV965eJ4mmCqzW4X8/t7aGDVjXRP1Y/wP6ms=";
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

  meta = {
    homepage = "https://github.com/EliverLara/candy-icons";
    description = "Icon theme colored with sweet gradients";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      clr-cera
      arunoruto
    ];
  };
}
