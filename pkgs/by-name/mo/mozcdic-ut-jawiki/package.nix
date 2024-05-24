{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-jawiki";
  version = "0-unstable-2024-08-23";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-jawiki";
    rev = "08814f70cc0cc9b0f4757fa46f40d918dfd7073d";
    hash = "sha256-Sfw5cNXuno3aSUUPy9c3HODIu9cVSmskTwibD8w8jaM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-jawiki.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Mozc UT Jawiki Dictionary is a dictionary generated from the Japanese Wikipedia for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-jawiki";
    license = with lib.licenses; [
      asl20
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
