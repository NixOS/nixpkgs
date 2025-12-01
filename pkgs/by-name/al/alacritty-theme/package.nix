{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (self: {
  pname = "alacritty-theme";
  version = "0-unstable-2025-11-16";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "f82c742634b5e840731dd7c609e95231917681a5";
    hash = "sha256-L5Sfex+9DGMLd4Be0w+BzNKdFCVXPBtnyBHQ6O0wPaU=";
    sparseCheckout = [ "themes" ];
  };

  dontConfigure = true;
  dontBuild = true;

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
