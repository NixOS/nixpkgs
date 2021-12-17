/*

  This file is for options that NixOS and nix-darwin have in common.

  Platform-specific code is in the respective default.nix files.

*/

{ config, lib, options, pkgs, ... }:
let
  inherit (lib)
    filterAttrs
    literalDocBook
    literalExpression
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
      apiBaseUrl = mkOption {
        description = ''
          API base URL that the agent will connect to.

          When using Hercules CI Enterprise, set this to the URL where your
          Hercules CI server is reachable.
        '';
        type = types.str;
        default = "https://hercules-ci.com";
      };
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

          A task is a single derivation build, an evaluation or an effect run.
          At minimum, you need 2 concurrent tasks for <literal>x86_64-linux</literal>
          in your cluster, to allow for import from derivation.

          <literal>concurrentTasks</literal> can be around the CPU core count or lower if memory is
          the bottleneck.

          The optimal value depends on the resource consumption characteristics of your workload,
          including memory usage and in-task parallelism. This is typically determined empirically.

          When scaling, it is generally better to have a double-size machine than two machines,
          because each split of resources causes inefficiencies; particularly with regards
          to build latency because of extra downloads.
        '';
        type = types.either types.ints.positive (types.enum [ "auto" ]);
        default = "auto";
      };
      labels = mkOption {
        description = ''
          A key-value map of user data.

          This data will be available to organization members in the dashboard and API.

          The values can be of any TOML type that corresponds to a JSON type, but arrays
          can not contain tables/objects due to limitations of the TOML library. Values
          involving arrays of non-primitive types may not be representable currently.
        '';
        type = format.type;
        defaultText = literalExpression ''
          {
            agent.source = "..."; # One of "nixpkgs", "flake", "override"
            lib.version = "...";
            pkgs.version = "...";
          }
        '';
      };
      workDirectory = mkOption {
        description = ''
          The directory in which temporary subdirectories are created for task state. This includes sources for Nix evaluation.
        '';
        type = types.path;
        default = config.baseDirectory + "/work";
        defaultText = literalExpression ''baseDirectory + "/work"'';
      };
      staticSecretsDirectory = mkOption {
        description = ''
          This is the default directory to look for statically configured secrets like <literal>cluster-join-token.key</literal>.

          See also <literal>clusterJoinTokenPath</literal> and <literal>binaryCachesPath</literal> for fine-grained configuration.
        '';
        type = types.path;
        default = config.baseDirectory + "/secrets";
        defaultText = literalExpression ''baseDirectory + "/secrets"'';
      };
      clusterJoinTokenPath = mkOption {
        description = ''
          Location of the cluster-join-token.key file.

          You can retrieve the contents of the file when creating a new agent via
          <link xlink:href="https://hercules-ci.com/dashboard">https://hercules-ci.com/dashboard</link>.

          As this value is confidential, it should not be in the store, but
          installed using other means, such as agenix, NixOps
          <literal>deployment.keys</literal>, or manual installation.

          The contents of the file are used for authentication between the agent and the API.
        '';
        type = types.path;
        default = config.staticSecretsDirectory + "/cluster-join-token.key";
        defaultText = literalExpression ''staticSecretsDirectory + "/cluster-join-token.key"'';
      };
      binaryCachesPath = mkOption {
        description = ''
          Path to a JSON file containing binary cache secret keys.

          As these values are confidential, they should not be in the store, but
          copied over using other means, such as agenix, NixOps
          <literal>deployment.keys</literal>, or manual installation.

          The format is described on <link xlink:href="https://docs.hercules-ci.com/hercules-ci-agent/binary-caches-json/">https://docs.hercules-ci.com/hercules-ci-agent/binary-caches-json/</link>.
        '';
        type = types.path;
        default = config.staticSecretsDirectory + "/binary-caches.json";
        defaultText = literalExpression ''staticSecretsDirectory + "/binary-caches.json"'';
      };
      secretsJsonPath = mkOption {
        description = ''
          Path to a JSON file containing secrets for effects.

          As these values are confidential, they should not be in the store, but
          copied over using other means, such as agenix, NixOps
          <literal>deployment.keys</literal>, or manual installation.

          The format is described on <link xlink:href="https://docs.hercules-ci.com/hercules-ci-agent/secrets-json/">https://docs.hercules-ci.com/hercules-ci-agent/secrets-json/</link>.

        '';
        type = types.path;
        default = config.staticSecretsDirectory + "/secrets.json";
        defaultText = literalExpression ''staticSecretsDirectory + "/secrets.json"'';
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
        dontConfigure = true;
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
      defaultText = literalExpression "pkgs.hercules-ci-agent";
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
      defaultText = literalDocBook "generated <literal>hercules-ci-agent.toml</literal>";
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
    services.hercules-ci-agent = {
      tomlFile =
        format.generate "hercules-ci-agent.toml" cfg.settings;

      settings.labels = {
        agent.source =
          if options.services.hercules-ci-agent.package.highestPrio == (lib.modules.mkOptionDefault { }).priority
          then "nixpkgs"
          else lib.mkOptionDefault "override";
        pkgs.version = pkgs.lib.version;
        lib.version = lib.version;
      };
    };
  };
}
