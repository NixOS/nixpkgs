{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "alacritty-theme";
  version = "0-unstable-2026-06-12";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "659d2e1d669cd5722f11e58c44fd45dc26a6ffcd";
    hash = "sha256-1GMpnDdfzBIMm9fzQjxYgLNUGA3amvGYgO3VRcd49ro=";
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
