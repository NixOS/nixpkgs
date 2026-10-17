{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-alt-cannadic";
  version = "0-unstable-2026-09-05";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-alt-cannadic";
    rev = "e7230d7f6d9b72cb656a1eb23d2ccdb7c70d141f";
    hash = "sha256-1+JjR8rAKtOa2lhMH3m8GKIz3UC8U7XVWelgXXn7310=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-alt-cannadic.txt.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Dictionary converted from alt-cannadic for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-alt-cannadic";
    license = with lib.licenses; [
      asl20
      gpl2
    ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
}
