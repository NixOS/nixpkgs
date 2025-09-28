{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-alt-cannadic";
  version = "0-unstable-2024-10-13";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-alt-cannadic";
    rev = "7f70e48a63735c781b6453977628e594bdd50d89";
    hash = "sha256-R7qU2YNdeojuu4VTxH+M5Bvf8XAEvK6N8jPNz9MQqvU=";
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
    description = "Dictionary converted from alt-cannadic for Mozc";
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
