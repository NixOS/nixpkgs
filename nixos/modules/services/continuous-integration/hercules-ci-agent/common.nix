/*

This file is for options that NixOS and nix-darwin have in common.

Platform-specific code is in the respective default.nix files.

 */

{ config, lib, options, pkgs, ... }:
let
  inherit (lib)
    filterAttrs
    literalExample
    mkIf
    mkOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    types
    ;

  cfg =
    config.services.hercules-ci-agent;

  format = pkgs.formats.toml { };

  settingsModule = { config, ... }: {
    freeformType = format.type;
    options = {
      baseDirectory = mkOption {
        type = types.path;
        default = "/var/lib/hercules-ci-agent";
        description = ''
          State directory (secrets, work directory, etc) for agent
        '';
      };
      concurrentTasks = mkOption {
        description = ''
          Number of tasks to perform simultaneously.

          A task is a single derivation build or an evaluation.
          At minimum, you need 2 concurrent tasks for <literal>x86_64-linux</literal>
          in your cluster, to allow for import from derivation.

          <literal>concurrentTasks</literal> can be around the CPU core count or lower if memory is
          the bottleneck.
        '';
        type = types.int;
        default = 4;
      };
      workDirectory = mkOption {
        description = ''
          The directory in which temporary subdirectories are created for task state. This includes sources for Nix evaluation.
        '';
        type = types.path;
        default = config.baseDirectory + "/work";
        defaultText = literalExample ''baseDirectory + "/work"'';
      };
      staticSecretsDirectory = mkOption {
        description = ''
          This is the default directory to look for statically configured secrets like <literal>cluster-join-token.key</literal>.
        '';
        type = types.path;
        default = config.baseDirectory + "/secrets";
        defaultText = literalExample ''baseDirectory + "/secrets"'';
      };
      clusterJoinTokenPath = mkOption {
        description = ''
          Location of the cluster-join-token.key file.
        '';
        type = types.path;
        default = config.staticSecretsDirectory + "/cluster-join-token.key";
        defaultText = literalExample ''staticSecretsDirectory + "/cluster-join-token.key"'';
        # internal: It's a bit too detailed to show by default in the docs,
        # but useful to define explicitly to allow reuse by other modules.
        internal = true;
      };
      binaryCachesPath = mkOption {
        description = ''
          Location of the binary-caches.json file.
        '';
        type = types.path;
        default = config.staticSecretsDirectory + "/binary-caches.json";
        defaultText = literalExample ''staticSecretsDirectory + "/binary-caches.json"'';
        # internal: It's a bit too detailed to show by default in the docs,
        # but useful to define explicitly to allow reuse by other modules.
        internal = true;
      };
    };
  };

  # TODO (roberth, >=2022) remove
  checkNix =
    if !cfg.checkNix
    then ""
    else if lib.versionAtLeast config.nix.package.version "2.3.10"
    then ""
    else
      pkgs.stdenv.mkDerivation {
        name = "hercules-ci-check-system-nix-src";
        inherit (config.nix.package) src patches;
        configurePhase = ":";
        buildPhase = ''
          echo "Checking in-memory pathInfoCache expiry"
          if ! grep 'PathInfoCacheValue' src/libstore/store-api.hh >/dev/null; then
            cat 1>&2 <<EOF

            You are deploying Hercules CI Agent on a system with an incompatible
            nix-daemon. Please make sure nix.package is set to a Nix version of at
            least 2.3.10 or a master version more recent than Mar 12, 2020.
          EOF
            exit 1
          fi
        '';
        installPhase = "touch $out";
      };

in
{
  imports = [
    (mkRenamedOptionModule [ "services" "hercules-ci-agent" "extraOptions" ] [ "services" "hercules-ci-agent" "settings" ])
    (mkRenamedOptionModule [ "services" "hercules-ci-agent" "baseDirectory" ] [ "services" "hercules-ci-agent" "settings" "baseDirectory" ])
    (mkRenamedOptionModule [ "services" "hercules-ci-agent" "concurrentTasks" ] [ "services" "hercules-ci-agent" "settings" "concurrentTasks" ])
    (mkRemovedOptionModule [ "services" "hercules-ci-agent" "patchNix" ] "Nix versions packaged in this version of Nixpkgs don't need a patched nix-daemon to work correctly in Hercules CI Agent clusters.")
  ];

  options.services.hercules-ci-agent = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable to run Hercules CI Agent as a system service.

        <link xlink:href="https://hercules-ci.com">Hercules CI</link> is a
        continuous integation service that is centered around Nix.

        Support is available at <link xlink:href="mailto:help@hercules-ci.com">help@hercules-ci.com</link>.
      '';
    };
    checkNix = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to make sure that the system's Nix (nix-daemon) is compatible.

        If you set this to false, please keep up with the change log.
      '';
    };
    package = mkOption {
      description = ''
        Package containing the bin/hercules-ci-agent executable.
      '';
      type = types.package;
      default = pkgs.hercules-ci-agent;
      defaultText = literalExample "pkgs.hercules-ci-agent";
    };
    settings = mkOption {
      description = ''
        These settings are written to the <literal>agent.toml</literal> file.

        Not all settings are listed as options, can be set nonetheless.

        For the exhaustive list of settings, see <link xlink:href="https://docs.hercules-ci.com/hercules-ci/reference/agent-config/"/>.
      '';
      type = types.submoduleWith { modules = [ settingsModule ]; };
    };

    /*
      Internal and/or computed values.

      These are written as options instead of let binding to allow sharing with
      default.nix on both NixOS and nix-darwin.
     */
    tomlFile = mkOption {
      type = types.path;
      internal = true;
      defaultText = "generated hercules-ci-agent.toml";
      description = ''
        The fully assembled config file.
      '';
    };
  };

  config = mkIf cfg.enable {
    nix.extraOptions = lib.addContextFrom checkNix ''
      # A store path that was missing at first may well have finished building,
      # even shortly after the previous lookup. This *also* applies to the daemon.
      narinfo-cache-negative-ttl = 0
    '';
    services.hercules-ci-agent.tomlFile =
      format.generate "hercules-ci-agent.toml" cfg.settings;
  };
}
