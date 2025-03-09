{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "jawiki-all-titles-in-ns0";
  version = "0-unstable-2024-12-01";

  src = fetchFromGitHub {
    owner = "musjj";
    repo = "jawiki-archive";
    rev = "a4146faaca34c37a36f26e1e75990187cac40954";
    hash = "sha256-FuLtXgyEpHZWeZbbrKXalXeycf7gtkfWMYoM7j2mOds=";
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
