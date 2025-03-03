{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "candy-icons";
  version = "0-unstable-2025-02-23";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "75e873759d68b0fe3b52c7939edeb83f01db769b";
    hash = "sha256-tBO8aw4hYe0DxQovdJ39uWhRAQWqR06Prq9XIz1OADk=";
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
