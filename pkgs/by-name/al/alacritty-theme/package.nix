{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "alacritty-theme";
  version = "0-unstable-2026-07-10";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "03cce642656759f440c97bb99ce65fc1c5b064a1";
    hash = "sha256-JfvBUsmw3lRxOj2lb9yVmkRwfUpjJwjBujwztoXtgMY=";
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
