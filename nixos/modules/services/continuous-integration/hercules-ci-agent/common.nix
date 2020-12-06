/*

This file is for options that NixOS and nix-darwin have in common.

Platform-specific code is in the respective default.nix files.

 */

{ config, lib, options, pkgs, ... }:

let
  inherit (lib) mkOption mkIf types filterAttrs literalExample mkRenamedOptionModule;

  cfg =
    config.services.hercules-ci-agent;

  format = pkgs.formats.toml {};

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
          Number of tasks to perform simultaneously, such as evaluations, derivations.

          You must have a total capacity across agents of at least 2 concurrent tasks on <literal>x86_64-linux</literal>
          to allow for import from derivation.
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

  checkNix =
    if !cfg.checkNix
    then ""
    else if lib.versionAtLeast config.nix.package.version "2.4.0"
    then ""
    else pkgs.stdenv.mkDerivation {
      name = "hercules-ci-check-system-nix-src";
      inherit (config.nix.package) src patches;
      configurePhase = ":";
      buildPhase = ''
        echo "Checking in-memory pathInfoCache expiry"
        if ! grep 'struct PathInfoCacheValue' src/libstore/store-api.hh >/dev/null; then
          cat 1>&2 <<EOF

          You are deploying Hercules CI Agent on a system with an incompatible
          nix-daemon. Please
           - either upgrade Nix to version 2.4.0 (when released),
           - or set option services.hercules-ci-agent.patchNix = true;
           - or set option nix.package to a build of Nix 2.3 with this patch applied:
               https://github.com/NixOS/nix/pull/3405

          The patch is required for Nix-daemon clients that expect a change in binary
          cache contents while running, like the agent's evaluator. Without it, import
          from derivation will fail if your cluster has more than one machine.
          We are conservative with changes to the overall system, which is why we
          keep changes to a minimum and why we ask for confirmation in the form of
          services.hercules-ci-agent.patchNix = true before applying.

        EOF
          exit 1
        fi
      '';
      installPhase = "touch $out";
    };

  patchedNix = lib.mkIf (!lib.versionAtLeast pkgs.nix.version "2.4.0") (
    if lib.versionAtLeast pkgs.nix.version "2.4pre"
    then lib.warn "Hercules CI Agent module will not patch 2.4 pre-release. Make sure it includes (equivalently) PR #3043, commit d048577909 or is no older than 2020-03-13." pkgs.nix
    else pkgs.nix.overrideAttrs (
      o: {
        patches = (o.patches or []) ++ [ backportNix3398 ];
      }
    )
  );

  backportNix3398 = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/hercules-ci/hercules-ci-agent/hercules-ci-agent-0.7.3/for-upstream/issue-3398-path-info-cache-ttls-backport-2.3.patch";
    sha256 = "0jfckqjir9il2il7904yc1qyadw366y7xqzg81sp9sl3f1pw70ib";
  };
in
{
  imports = [
    (mkRenamedOptionModule ["services" "hercules-ci-agent" "extraOptions"] ["services" "hercules-ci-agent" "settings"])
    (mkRenamedOptionModule ["services" "hercules-ci-agent" "baseDirectory"] ["services" "hercules-ci-agent" "settings" "baseDirectory"])
    (mkRenamedOptionModule ["services" "hercules-ci-agent" "concurrentTasks"] ["services" "hercules-ci-agent" "settings" "concurrentTasks"])
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
    patchNix = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Fix Nix 2.3 cache path metadata caching behavior. Has the effect of <literal>nix.package = patch pkgs.nix;</literal>

        This option will be removed when Hercules CI Agent moves to Nix 2.4 (upcoming Nix release).
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
    nix.package = mkIf cfg.patchNix patchedNix;
    services.hercules-ci-agent.tomlFile =
      format.generate "hercules-ci-agent.toml" cfg.settings;
  };
}
