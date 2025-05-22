{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenvNoCC,
  ...
}:

stdenvNoCC.mkDerivation (self: {
  pname = "alacritty-theme";
  version = "0-unstable-2025-05-15";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "59a96ef4c734f97a1aadaa619b31cc1ca90a0fbc";
    hash = "sha256-7Qu00+odZblXqN9e3uVZWfIWySFT0IiwIyK5wEbtReE=";
    sparseCheckout = [ "themes" ];
  };

  dontConfigure = true;
  dontBuild = true;
  preferLocalBuild = true;

  sourceRoot = "${self.src.name}/themes";
  installPhase = ''
    runHook preInstall
    install -Dt $out/share/alacritty-theme *.toml
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Collection of Alacritty color schemes";
    homepage = "https://alacritty.org/";
    license = licenses.asl20;
    maintainers = [ maintainers.nicoo ];
    platforms = platforms.all;
  };
})
