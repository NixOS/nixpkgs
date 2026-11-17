{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-sudachidict";
  version = "0-unstable-2026-10-16";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-sudachidict";
    rev = "13129ddebe1cb8eabb63feccbe157adec4e1de01";
    hash = "sha256-RIOmVNh22aX1pty2kKFwDBYg57fs2pKYZ+jBNOPxgNg=";
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
