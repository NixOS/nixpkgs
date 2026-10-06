{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-sudachidict";
  version = "0-unstable-2026-07-24";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-sudachidict";
    rev = "c686771bada1d59e9b105c81b29e6ac1a239cb54";
    hash = "sha256-UjntnOfSxit22ZyVtzi6znB0C2JfErw+8MAwvg5cyV4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-sudachidict.txt.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Dictionary converted from SudachiDict for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-sudachidict";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
}
