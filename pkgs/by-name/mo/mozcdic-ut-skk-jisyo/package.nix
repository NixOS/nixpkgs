{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-skk-jisyo";
  version = "0-unstable-2024-04-23";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-skk-jisyo";
    rev = "5a996bfd369ee44ec681f86bb7880904e9171cdd";
    hash = "sha256-aL3lp+ZdVmcbQr7o7oGUcGPRhjBZtvrD+EC1FkWc1xA=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-skk-jisyo.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

  meta = {
    description = "Mozc UT SKK-JISYO Dictionary is a dictionary converted from SKK-JISYO for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-sudachidict";
    license = with lib.licenses;[ asl20 gpl2 ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
