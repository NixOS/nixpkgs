{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "jawiki-all-titles-in-ns0";
  version = "0-unstable-2025-09-01";

  src = fetchFromGitHub {
    owner = "musjj";
    repo = "jawiki-archive";
    rev = "bcb0ee245aee3ba7769ceec6caf9696c8bae1624";
    hash = "sha256-Vb+8XE9FFEJfp6++WWr5fT6oWkF8eUtvYLz9ouRHWHA=";
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
    description = "Jawiki dump list of page titles in main namespace";
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
