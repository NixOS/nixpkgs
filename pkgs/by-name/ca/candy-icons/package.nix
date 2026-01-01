{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "candy-icons";
<<<<<<< HEAD
  version = "0-unstable-2025-12-26";
=======
  version = "0-unstable-2025-11-01";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
<<<<<<< HEAD
    rev = "1ec7ed314104847d6bffdc89ef67663917a67268";
    hash = "sha256-p8WZTNHwYTom0QnWvOU0JLRbEYZlGQq/QPpK3KlwBH8=";
=======
    rev = "1be42f22a36813b8b992f37c1ce56d886a4f97cf";
    hash = "sha256-suQ2yvKsMbm0a4Qg9D3THMa1gCpZSlOF0plD0H8vYy8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/EliverLara/candy-icons";
    description = "Icon theme colored with sweet gradients";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://github.com/EliverLara/candy-icons";
    description = "Icon theme colored with sweet gradients";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      clr-cera
      arunoruto
    ];
  };
}
