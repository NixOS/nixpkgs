{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-skk-jisyo";
  version = "0-unstable-2026-04-19";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-skk-jisyo";
    rev = "7c02e535bd6d999a715a53b58c3366f2401bfb7f";
    hash = "sha256-Ew8mzdhQHzCHSkwo9HzPKduSPrH0BZx/YNEsoOPLe3I=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-skk-jisyo.txt.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Dictionary converted from SKK-JISYO for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-sudachidict";
    license = with lib.licenses; [
      asl20
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
}
