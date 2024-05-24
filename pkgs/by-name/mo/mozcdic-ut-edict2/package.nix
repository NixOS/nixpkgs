{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-edict2";
  version = "0-unstable-2024-04-23";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-edict2";
    rev = "4a08ebf0397c65991b5f6d7f4dd2cbc583a12c83";
    hash = "sha256-958l0Q9GKmyZojaPtyq1hD+TxSk1VHJdayrdZV6oGBQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-edict2.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

  meta = {
    description = "Mozc UT EDICT2 Dictionary is a dictionary converted from EDICT2 for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-sudachidict";
    license = with lib.licenses;[ asl20 cc-by-sa-40 ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
