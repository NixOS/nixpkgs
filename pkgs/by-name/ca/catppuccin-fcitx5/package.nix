{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-fcitx5";
  version = "0-unstable-2022-10-05";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "fcitx5";
    rev = "ce244cfdf43a648d984719fdfd1d60aab09f5c97";
    hash = "sha256-uFaCbyrEjv4oiKUzLVFzw+UY54/h7wh2cntqeyYwGps=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fcitx5
    cp -r src $out/share/fcitx5/themes
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Soothing pastel theme for Fcitx5";
    homepage = "https://github.com/catppuccin/fcitx5";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pluiedev
      Guanran928
    ];
    platforms = lib.platforms.all;
  };
}
