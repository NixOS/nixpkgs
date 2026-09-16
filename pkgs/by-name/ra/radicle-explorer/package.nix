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
  version = "0-unstable-2026-09-03";

  src = fetchFromRadicle {
    seed = "seed.radicle.dev";
    repo = "z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    rev = "fb11e4d9c2c758468b9dca5c615f2392fb011c6e";
    hash = "sha256-X8YRmyK8VyhmRMnKEiIhbiNyQ/fy4U9FgcIARDz+MfI=";
  };

  npmDepsHash = "sha256-m+md3XIjn4SpZ3vp5STDFAKU3QSs0maFUm3Ll5DLghc=";

  preBuild = ''
    if [[ $configFile ]]; then
      cp "$configFile" config/local.json
    fi
  '';

  installPhase = ''
    runHook preInstall

    mv build $out

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
    (nix-update-script { extraArgs = [ "--version=skip" ]; })
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
