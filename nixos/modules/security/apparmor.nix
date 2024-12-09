{ config, lib, pkgs, ... }:
let
  inherit (builtins) attrNames head map match readFile;
  inherit (lib) types;
  inherit (config.environment) etc;
  cfg = config.security.apparmor;
  mkDisableOption = name: lib.mkEnableOption name // {
    default = true;
    example = false;
  };
  enabledPolicies = lib.filterAttrs (n: p: p.enable) cfg.policies;
in

{
  imports = [
    (lib.mkRemovedOptionModule [ "security" "apparmor" "confineSUIDApplications" ] "Please use the new options: `security.apparmor.policies.<policy>.enable'.")
    (lib.mkRemovedOptionModule [ "security" "apparmor" "profiles" ] "Please use the new option: `security.apparmor.policies'.")
    apparmor/includes.nix
    apparmor/profiles.nix
  ];

  options = {
    security.apparmor = {
      enable = lib.mkEnableOption ''
        the AppArmor Mandatory Access Control system.

        If you're enabling this module on a running system,
        note that a reboot will be required to activate AppArmor in the kernel.

        Also, beware that enabling this module privileges stability over security
        by not trying to kill unconfined but newly confinable running processes by default,
        though it would be needed because AppArmor can only confine new
        or already confined processes of an executable.
        This killing would for instance be necessary when upgrading to a NixOS revision
        introducing for the first time an AppArmor profile for the executable
        of a running process.

        Enable [](#opt-security.apparmor.killUnconfinedConfinables)
        if you want this service to do such killing
        by sending a `SIGTERM` to those running processes'';
      policies = lib.mkOption {
        description = ''
          AppArmor policies.
        '';
        type = types.attrsOf (types.submodule ({ name, config, ... }: {
          options = {
            enable = mkDisableOption "loading of the profile into the kernel";
            enforce = mkDisableOption "enforcing of the policy or only complain in the logs";
            profile = lib.mkOption {
              description = "The policy of the profile.";
              type = types.lines;
              apply = pkgs.writeText name;
            };
          };
        }));
        default = {};
      };
      includes = lib.mkOption {
        type = types.attrsOf types.lines;
        default = {};
        description = ''
          List of paths to be added to AppArmor's searched paths
          when resolving `include` directives.
        '';
        apply = lib.mapAttrs pkgs.writeText;
      };
      packages = lib.mkOption {
        type = types.listOf types.package;
        default = [];
        description = "List of packages to be added to AppArmor's include path";
      };
      enableCache = lib.mkEnableOption ''
        caching of AppArmor policies
        in `/var/cache/apparmor/`.

        Beware that AppArmor policies almost always contain Nix store paths,
        and thus produce at each change of these paths
        a new cached version accumulating in the cache'';
      killUnconfinedConfinables = lib.mkEnableOption ''
        killing of processes which have an AppArmor profile enabled
        (in [](#opt-security.apparmor.policies))
        but are not confined (because AppArmor can only confine new processes).

        This is only sending a gracious `SIGTERM` signal to the processes,
        not a `SIGKILL`.

        Beware that due to a current limitation of AppArmor,
        only profiles with exact paths (and no name) can enable such kills'';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = map (policy:
      { assertion = match ".*/.*" policy == null;
        message = "`security.apparmor.policies.\"${policy}\"' must not contain a slash.";
        # Because, for instance, aa-remove-unknown uses profiles_names_list() in rc.apparmor.functions
        # which does not recurse into sub-directories.
      }
    ) (attrNames cfg.policies);

    environment.systemPackages = [
      pkgs.apparmor-utils
      pkgs.apparmor-bin-utils
    ];
    environment.etc."apparmor.d".source = pkgs.linkFarm "apparmor.d" (
      # It's important to put only enabledPolicies here and not all cfg.policies
      # because aa-remove-unknown reads profiles from all /etc/apparmor.d/*
      lib.mapAttrsToList (name: p: { inherit name; path = p.profile; }) enabledPolicies ++
      lib.mapAttrsToList (name: path: { inherit name path; }) cfg.includes
    );
    environment.etc."apparmor/parser.conf".text = ''
        ${if cfg.enableCache then "write-cache" else "skip-cache"}
        cache-loc /var/cache/apparmor
        Include /etc/apparmor.d
      '' +
      lib.concatMapStrings (p: "Include ${p}/etc/apparmor.d\n") cfg.packages;
    # For aa-logprof
    environment.etc."apparmor/apparmor.conf".text = ''
    '';
    # For aa-logprof
    environment.etc."apparmor/severity.db".source = pkgs.apparmor-utils + "/etc/apparmor/severity.db";
    environment.etc."apparmor/logprof.conf".source = pkgs.runCommand "logprof.conf" {
      header = ''
        [settings]
          # /etc/apparmor.d/ is read-only on NixOS
          profiledir = /var/cache/apparmor/logprof
          inactive_profiledir = /etc/apparmor.d/disable
          # Use: journalctl -b --since today --grep audit: | aa-logprof
          logfiles = /dev/stdin

          parser = ${pkgs.apparmor-parser}/bin/apparmor_parser
          ldd = ${pkgs.glibc.bin}/bin/ldd
          logger = ${pkgs.util-linux}/bin/logger

          # customize how file ownership permissions are presented
          # 0 - off
          # 1 - default of what ever mode the log reported
          # 2 - force the new permissions to be user
          # 3 - force all perms on the rule to be user
          default_owner_prompt = 1

          custom_includes = /etc/apparmor.d ${lib.concatMapStringsSep " " (p: "${p}/etc/apparmor.d") cfg.packages}

        [qualifiers]
          ${pkgs.runtimeShell} = icnu
          ${pkgs.bashInteractive}/bin/sh = icnu
          ${pkgs.bashInteractive}/bin/bash = icnu
          ${config.users.defaultUserShell} = icnu
      '';
      footer = "${pkgs.apparmor-utils}/etc/apparmor/logprof.conf";
      passAsFile = [ "header" ];
    } ''
      cp $headerPath $out
      sed '1,/\[qualifiers\]/d' $footer >> $out
    '';

    boot.kernelParams = [ "apparmor=1" "security=apparmor" ];

    systemd.services.apparmor = {
      after = [
        "local-fs.target"
        "systemd-journald-audit.socket"
      ];
      before = [ "sysinit.target" "shutdown.target" ];
      conflicts = [ "shutdown.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        Description="Load AppArmor policies";
        DefaultDependencies = "no";
        ConditionSecurity = "apparmor";
      };
      # Reloading instead of restarting enables to load new AppArmor profiles
      # without necessarily restarting all services which have Requires=apparmor.service
      reloadIfChanged = true;
      restartTriggers = [
        etc."apparmor/parser.conf".source
        etc."apparmor.d".source
      ];
      serviceConfig = let
        killUnconfinedConfinables = pkgs.writeShellScript "apparmor-kill" ''
          set -eu
          ${pkgs.apparmor-bin-utils}/bin/aa-status --json |
          ${pkgs.jq}/bin/jq --raw-output '.processes | .[] | .[] | select (.status == "unconfined") | .pid' |
          xargs --verbose --no-run-if-empty --delimiter='\n' \
          kill
        '';
        commonOpts = p: "--verbose --show-cache ${lib.optionalString (!p.enforce) "--complain "}${p.profile}";
        in {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStartPre = "${pkgs.apparmor-utils}/bin/aa-teardown";
        ExecStart = lib.mapAttrsToList (n: p: "${pkgs.apparmor-parser}/bin/apparmor_parser --add ${commonOpts p}") enabledPolicies;
        ExecStartPost = lib.optional cfg.killUnconfinedConfinables killUnconfinedConfinables;
        ExecReload =
          # Add or replace into the kernel profiles in enabledPolicies
          # (because AppArmor can do that without stopping the processes already confined).
          lib.mapAttrsToList (n: p: "${pkgs.apparmor-parser}/bin/apparmor_parser --replace ${commonOpts p}") enabledPolicies ++
          # Remove from the kernel any profile whose name is not
          # one of the names within the content of the profiles in enabledPolicies
          # (indirectly read from /etc/apparmor.d/*, without recursing into sub-directory).
          # Note that this does not remove profiles dynamically generated by libvirt.
          [ "${pkgs.apparmor-utils}/bin/aa-remove-unknown" ] ++
          # Optionally kill the processes which are unconfined but now have a profile loaded
          # (because AppArmor can only start to confine new processes).
          lib.optional cfg.killUnconfinedConfinables killUnconfinedConfinables;
        ExecStop = "${pkgs.apparmor-utils}/bin/aa-teardown";
        CacheDirectory = [ "apparmor" "apparmor/logprof" ];
        CacheDirectoryMode = "0700";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ julm grimmauld ];
}
