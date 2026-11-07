{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "alacritty-theme";
  version = "0-unstable-2026-10-29";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "95615789c5eddee1c5407a520cd9959a86fa4716";
    hash = "sha256-2csu0UVt5o8lVp6YO4A7Va35QV4ZqkMd3JZSNBus1hk=";
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
