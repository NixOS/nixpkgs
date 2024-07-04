{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    ;
  json = pkgs.formats.json { };
  cfg = config.services.renovate;
  generateValidatedConfig =
    name: value:
    pkgs.callPackage (
      { runCommand, jq }:
      runCommand name
        {
          nativeBuildInputs = [
            jq
            cfg.package
          ];
          value = builtins.toJSON value;
          passAsFile = [ "value" ];
          preferLocalBuild = true;
        }
        ''
          jq . "$valuePath"> $out
          renovate-config-validator $out
        ''
    ) { };
  generateConfig = if cfg.validateSettings then generateValidatedConfig else json.generate;
in
{
  meta.maintainers = with lib.maintainers; [ marie natsukium ];

  options.services.renovate = {
    enable = mkEnableOption "renovate";
    package = mkPackageOption pkgs "renovate" { };
    schedule = mkOption {
      type = with types; nullOr str;
      description = "How often to run renovate. See {manpage}`systemd.time(7)` for the format.";
      example = "*:0/10";
      default = null;
    };
    credentials = mkOption {
      type = with types; attrsOf path;
      description = ''
        Allows configuring environment variable credentials for renovate, read from files.
        This should always be used for passing confidential data to renovate.
      '';
      example = {
        RENOVATE_TOKEN = "/etc/renovate/token";
      };
      default = { };
    };
    runtimePackages = mkOption {
      type = with types; listOf package;
      description = "Packages available to renovate.";
      default = [ ];
    };
    validateSettings = mkOption {
      type = types.bool;
      default = true;
      description = "Weither to run renovate's config validator on the built configuration.";
    };
    settings = mkOption {
      type = json.type;
      default = { };
      example = {
        platform = "gitea";
        endpoint = "https://git.example.com";
        gitAuthor = "Renovate <renovate@example.com>";
      };
      description = ''
        Renovate's global configuration.
        If you want to pass secrets to renovate, please use {option}`services.renovate.credentials` for that.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.renovate.settings = {
      cacheDir = "/var/cache/renovate";
      baseDir = "/var/lib/renovate";
    };

    systemd.services.renovate = {
      description = "Renovate dependency updater";
      documentation = [ "https://docs.renovatebot.com/" ];
      after = [ "network.target" ];
      startAt = lib.optional (cfg.schedule != null) cfg.schedule;
      path = [
        config.systemd.package
        pkgs.git
      ] ++ cfg.runtimePackages;

      serviceConfig = {
        Type = "oneshot";
        User = "renovate";
        Group = "renovate";
        DynamicUser = true;
        LoadCredential = lib.mapAttrsToList (name: value: "SECRET-${name}:${value}") cfg.credentials;
        RemainAfterExit = false;
        Restart = "on-failure";
        CacheDirectory = "renovate";
        StateDirectory = "renovate";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };

      script = ''
        ${lib.concatStringsSep "\n" (
          builtins.map (name: "export ${name}=$(systemd-creds cat 'SECRET-${name}')") (
            lib.attrNames cfg.credentials
          )
        )}
        exec ${lib.escapeShellArg (lib.getExe cfg.package)}
      '';

      environment = {
        RENOVATE_CONFIG_FILE = generateConfig "renovate-config.json" cfg.settings;
        HOME = "/var/lib/renovate";
      };
    };
  };
}
