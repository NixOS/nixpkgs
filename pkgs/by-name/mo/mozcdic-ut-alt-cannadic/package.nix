{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-alt-cannadic";
  version = "0-unstable-2024-07-28";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-alt-cannadic";
    rev = "50fee0397b87fe508f9edd45bac56f5290d8ce66";
    hash = "sha256-KKUj3d9yR2kTTTFbroZQs+OZR4KUyAUYE/X3z9/vQvM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-alt-cannadic.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Mozc UT Alt-Cannadic Dictionary is a dictionary converted from Alt-Cannadic for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-alt-cannadic";
    license = with lib.licenses; [
      asl20
      gpl2
    ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
