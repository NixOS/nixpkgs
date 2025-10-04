{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (self: {
  pname = "alacritty-theme";
  version = "0-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "40e0c6c8690d1c62f58718fcef8a48eb6077740b";
    hash = "sha256-guNbnnSyENom6SkwN2Zjn3I1KnV5F3hbvYS1ns4q4uE=";
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
