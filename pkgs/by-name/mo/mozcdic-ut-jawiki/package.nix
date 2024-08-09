{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-jawiki";
  version = "0-unstable-2024-05-02";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-jawiki";
    rev = "c5dc0ae75d65efd4603c4cf0d81a23daf9e27dbd";
    hash = "sha256-ErIMiJkLLBJAU5/e3MFaTLvToqIJsqyirRuOY9lJiQs=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-jawiki.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

  meta = {
    description = "Mozc UT Jawiki Dictionary is a dictionary generated from the Japanese Wikipedia for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-jawiki";
    license = with lib.licenses;[ asl20 cc-by-sa-40 ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
