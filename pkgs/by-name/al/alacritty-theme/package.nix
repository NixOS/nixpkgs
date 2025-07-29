{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenvNoCC,
  ...
}:

stdenvNoCC.mkDerivation (self: {
  pname = "alacritty-theme";
  version = "0-unstable-2025-07-16";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "6c91a0e913396daafdb7ca43e84014d4e176623c";
    hash = "sha256-Rq5AB9BktTaCQ1UzUITgu6g5a74C0sHpiiHAjeC1RiA=";
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
