{
  radicle-httpd,
  fetchFromGitHub,
  lib,
  buildNpmPackage,
  writeText,
  jq,
  runCommand,
}:

let
  # radicle-explorer bundles these freely available Emoji assets, but does not
  # redistribute them.
  twemojiAssets = fetchFromGitHub {
    owner = "twitter";
    repo = "twemoji";
    rev = "v14.0.2";
    hash = "sha256-YoOnZ5uVukzi/6bLi22Y8U5TpplPzB7ji42l+/ys5xI=";
    meta.license = [ lib.licenses.cc-by-40 ];
  };

  mkPassthru = self: args: {
    # radicle-explorer is configured through static build time configuration.
    #
    # Using this function you can override the this configuration, for example,
    # to configure alternative preferred peers (which are shown in the UI by
    # default).
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
    withConfig =
      config:
      let
        overrides = writeText "config-overrides.json" (builtins.toJSON config);
        newConfig = runCommand "config.json" { } ''
          ${jq}/bin/jq -s '.[0] * .[1]' ${(self args).src}/config/default.json ${overrides} > $out
        '';
      in
      lib.fix (
        final:
        (self args).overrideAttrs (prev: {
          preBuild = ''
            ${prev.preBuild or ""}
            cp ${newConfig} config/local.json
          '';

          passthru = prev.passthru // mkPassthru final args;
        })
      );
  };
in
lib.fix (
  self:
  lib.makeOverridable (
    {
      npmDepsHash ? "sha256-7/DH0p66FTfC0N42FhWTqehg5m/yq929ANhL4jAt7Ss=",
      patches ? [ ],
    }@args:
    buildNpmPackage {
      pname = "radicle-explorer";
      version = radicle-httpd.version;
      inherit patches npmDepsHash;

      # radicle-explorer uses the radicle-httpd API, and they are developed in the
      # same repo. For this reason we pin the sources to each other, but due to
      # radicle-httpd using a more limited sparse checkout we need to carry a
      # separate hash.
      src = radicle-httpd.src.override {
        hash = "sha256-1OhZ0x21NlZIiTPCRpvdUsx5UmeLecTjVzH8DWllPr8=";
        sparseCheckout = [ ];
      };

      postPatch = ''
        patchShebangs --build ./scripts
        mkdir -p "public/twemoji"
        cp -t public/twemoji -r -- ${twemojiAssets}/assets/svg/*
        : >scripts/install-twemoji-assets
      '';

      dontConfigure = true;
      doCheck = false;

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r -t "$out" build/*
        runHook postInstall
      '';

      passthru = mkPassthru self args;

      meta = {
        description = "Web frontend for Radicle";
        longDescription = ''
          Radicle Explorer is a web-frontend for Radicle which supports browsing
          repositories, issues and patches on publicly available Radicle seeds.

          This package builds the web interface, ready to be served by any web
          server.
        '';

        homepage = "https://radicle.xyz";
        license = lib.licenses.gpl3;

        maintainers = with lib.maintainers; [
          tazjin
          lorenzleutgeb
        ];
      };
    }
  )
) { }
