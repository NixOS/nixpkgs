{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "candy-icons";
  version = "0-unstable-2026-01-13";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "42f5c4817f47e2ef4b011080ebbb2f50a9a6955b";
    hash = "sha256-d7jxoqWPRlNX43CdIEihT6kxvke3k8GG9CJkmlkuRNw=";
  };

  # Fix broken video-x-mng.svg symlink that crashes nix-index
  # https://github.com/EliverLara/candy-icons/pull/761
  postPatch = ''
    ln -sf video-webm.svg mimetypes/scalable/video-x-mng.svg
  '';

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
