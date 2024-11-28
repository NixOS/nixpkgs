{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "jawiki-all-titles-in-ns0";
  version = "0-unstable-2024-10-01";

  src = fetchFromGitHub {
    owner = "musjj";
    repo = "jawiki-archive";
    rev = "1e26e5efa36eea5322f55b178a5c4d5a5439feb9";
    hash = "sha256-8jzsECzrrcHeMvV2K89WagSiCXHjEDEfUwLDanVVuas=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp jawiki-latest-all-titles-in-ns0.gz $out/jawiki-all-titles-in-ns0.gz

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "A jawiki dump list of page titles in main namespace";
    homepage = "https://dumps.wikimedia.org/backup-index.html";
    license = with lib.licenses; [
      fdl13Only
      cc-by-sa-30
    ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides a dump gz file
    hydraPlatforms = [ ];
  };
}
