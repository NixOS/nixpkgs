{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "colloid-cursors";
  version = "0-unstable-2023-03-28";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Colloid-icon-theme";
    rev = "d8bfd7339e3ab97a0c08b3e373a895119cc78ca8";
    hash = "sha256-DOli7Ze1op1liU9xWku9tmQO0I711CstyqC+PYXvbJM=";
  };

  installPhase = ''
    runHook preInstall

    # Loosely based on the install script: https://github.com/vinceliuice/Colloid-icon-theme/blob/main/cursors/install.sh
    mkdir -p $out/share/icons
    cp -r cursors/dist $out/share/icons/Colloid-cursors
    cp -r cursors/dist-dark $out/share/icons/Colloid-dark-cursors

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Colloid cursor theme";
    homepage = "https://github.com/vinceliuice/Colloid-icon-theme/tree/main/cursors#readme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ xelacodes ];
  };
})
