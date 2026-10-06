{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-edict2";
  version = "0-unstable-2026-07-08";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-edict2";
    rev = "8fe8f7918baf513c3d7e243807dfcda2d5c30139";
    hash = "sha256-YCxAmNmHVfGS1VxExK5FWQOA/SXBNuamU9yIWmfN9VU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-edict2.txt.bz2

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
  };
}
