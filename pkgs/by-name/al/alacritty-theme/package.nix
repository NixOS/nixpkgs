{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "alacritty-theme";
  version = "0-unstable-2026-02-13";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "dcd837532011fcfc6941d0dc84b3271888309ee8";
    hash = "sha256-NkGM9rS1FQUDlFRXqGM9dlUMy7cwKxcSz+vFjQs+Tgg=";
    sparseCheckout = [ "themes" ];
  };

  preferLocalBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/alacritty-theme themes/*.toml
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Collection of Alacritty color schemes";
    homepage = "https://github.com/alacritty/alacritty-theme";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nicoo ];
    platforms = lib.platforms.all;
  };
}
