{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,

  withRoundedCorners ? false,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-fcitx5";
  version = "0-unstable-2025-05-16";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "fcitx5";
    rev = "393845cf3ed0e0000bfe57fe1b9ad75748e2547f";
    hash = "sha256-ss0kW+ulvMhxeZKBrjQ7E5Cya+02eJrGsE4OLEkqKks=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString withRoundedCorners ''
    find src -name theme.conf -exec sed -i -E 's/^# (Image=(panel|highlight).svg)/\1/' {} +
  ''
  + ''
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
