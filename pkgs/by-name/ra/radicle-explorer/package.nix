{
  lib,
  buildNpmPackage,
  fetchFromRadicle,
  writers,
  _experimental-update-script-combinators,
  unstableGitUpdater,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "radicle-explorer";
  version = "0-unstable-2026-11-23";

  src = fetchFromRadicle {
    seed = "seed.radicle.dev";
    repo = "z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    rev = "90166426ef452298dd2e76b7065fa0a43dea34d1";
    nonConeMode = true;
    sparseCheckout = [
      "/explorer"
      "/package-lock.json"
      "/package.json"
      "/shared"
    ];
    hash = "sha256-6piNgPZlpa7vDx9yD4hMACUjjesmODZ5CAirgOaEuQk=";
  };

  npmDepsHash = "sha256-snCaZtx4PVot+zo7iH8mLBLEzoGEb+wCfpKzoygXzlU=";

  npmWorkspace = "explorer";

  preBuild = ''
    if [[ $configFile ]]; then
      cp "$configFile" explorer/config/local.json
    fi
  '';

  installPhase = ''
    runHook preInstall

    mv explorer/build $out

    runHook postInstall
  '';

  # radicle-explorer is configured through static build time configuration.
  #
  # Using this function you can override this configuration, for example to
  # configure alternative preferred peers (which are shown in the UI by default).
  #
  # Example usage:
  #
  # ```nix
  # radicle-explorer.withConfig {
  #   preferredSeeds = [{
  #     hostname = "seed.example.com";
  #     port = 443;
  #     scheme = "https";
  #   }];
  # }
  # ```
  passthru.withConfig =
    config:
    finalAttrs.finalPackage.overrideAttrs { configFile = writers.writeJSON "config.json" config; };

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { hardcodeZeroVersion = true; })
    (nix-update-script {
      extraArgs = [
        "--version=skip"
        "--no-src"
      ];
    })
  ];

  meta = {
    description = "Web frontend for Radicle";
    longDescription = ''
      Radicle Explorer is a web-frontend for Radicle which supports browsing
      repositories, issues and patches on publicly available Radicle seeds.

      This package builds the web interface, ready to be served by any web
      server.
    '';
    homepage = "https://radicle.dev";
    license = lib.licenses.gpl3;
    teams = [ lib.teams.radicle ];
    maintainers = with lib.maintainers; [ tazjin ];
  };
})
