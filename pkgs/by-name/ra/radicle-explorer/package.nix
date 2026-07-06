{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  radicle-httpd,
  writers,
}:

let
  # radicle-explorer bundles these freely available Emoji assets, but does not
  # redistribute them.
  twemojiAssets = fetchFromGitHub {
    owner = "twitter";
    repo = "twemoji";
    tag = "v14.0.2";
    hash = "sha256-YoOnZ5uVukzi/6bLi22Y8U5TpplPzB7ji42l+/ys5xI=";
    meta.license = [ lib.licenses.cc-by-40 ];
  };
in

buildNpmPackage (finalAttrs: {
  pname = "radicle-explorer";
  inherit (radicle-httpd) version;

  # radicle-explorer uses the radicle-httpd API, and they are developed in the
  # same repo. For this reason we pin the sources to each other, but due to
  # radicle-httpd using a more limited sparse checkout we need to carry a
  # separate hash.
  src = radicle-httpd.src.override {
    hash = "sha256-cnQsPWkRChC8yPrICRoUpGW2GGLB2TK9+3v8ZRGe3x0=";
    sparseCheckout = [ ];
  };

  npmDepsHash = "sha256-8vmAs788PjdUTaQ5E8YLX0KiIPymJbH51oNaGZACe6I=";

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
