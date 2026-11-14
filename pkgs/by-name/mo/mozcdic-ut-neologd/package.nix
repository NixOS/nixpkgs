{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-neologd";
  version = "0-unstable-2026-04-19";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-neologd";
    rev = "d8307abf02b830b185c9320822cffa0d0787c54e";
    hash = "sha256-N00QZ9p5loD/ld6D1BB85tK/rvarRylWVCJqpnz47Ck=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-neologd.txt.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Dictionary converted from mecab-ipadic-NEologd for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-neologd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
}
