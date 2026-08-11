{
  lib,
  buildNpmPackage,
  fetchFromRadicle,
  fetchFromGitHub,
  writers,
  _experimental-update-script-combinators,
  unstableGitUpdater,
  nix-update-script,
}:

let
  # radicle-explorer bundles these freely available Emoji assets, but does not
  # redistribute them.
  twemojiAssets = fetchFromGitHub {
    owner = "twitter";
    repo = "twemoji";
    tag = "v14.0.2";
    hash = "sha256-YoOnZ5uVukzi/6bLi22Y8U5TpplPzB7ji42l+/ys5xI=";
    meta.license = lib.licenses.cc-by-40;
  };
in

buildNpmPackage (finalAttrs: {
  pname = "radicle-explorer";
  version = "0-unstable-2026-07-29";

  src = fetchFromRadicle {
    seed = "seed.radicle.dev";
    repo = "z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    rev = "427cece9850944d30f0d49ccd016f98dacd77d75";
    hash = "sha256-FC78GCaC8IcBtXDRotYcaw040cggGWnrI2lgnWLwU68=";
  };

  npmDepsHash = "sha256-L/JOhI7KVXNDGHzk8RVNNcd8hHL+I7YKVg8sZyRSBtA=";

  postPatch = ''
    patchShebangs --build ./scripts
    : >scripts/install-twemoji-assets

    cp -r "${twemojiAssets}/assets/svg" public/twemoji
  '';

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
