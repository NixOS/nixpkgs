{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-edict2";
  version = "0-unstable-2024-10-12";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-edict2";
    rev = "f68299b7113080d5e1981c97db490b3075874445";
    hash = "sha256-PdHGVudApWgQaxvAsdVui1XQR+4JHjGkhGHfcwL3wjc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-edict2.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Dictionary converted from EDICT2 for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-sudachidict";
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
