{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-personal-names";
  version = "0-unstable-2024-10-14";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-personal-names";
    rev = "24d783e5b1fe57af571e000861cfc70da173aedb";
    hash = "sha256-ezx4Am1xuP9SNNBsNC3KwpWghypRU97MCw10/P2LlnY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-personal-names.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Dictionary for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-personal-names";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
