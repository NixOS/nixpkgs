{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-place-names";
  version = "0-unstable-2026-10-02";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-place-names";
    rev = "98cf8e9d7731695a52e5bc72ed633933c71d1913";
    hash = "sha256-NIeV5iSTSJE867VqtUlcbyegMHpszFuZwOkHQlhJdhM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-place-names.txt.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Dictionary converted from the Japan Post's ZIP code data for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-place-names";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
}
