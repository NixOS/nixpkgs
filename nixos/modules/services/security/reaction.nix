{
  lib,
  pkgs,
  config,
  ...
}:
let
  settingsFormat = pkgs.formats.yaml { };

  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    types
    ;
in
{
  options.services.reaction = {
    enable = mkEnableOption "enable reaction";

    package = mkPackageOption pkgs "reaction" { };

    settings = mkOption {
      description = ''
        Configuration for reaction. See the [wiki](https://framagit.org/ppom/reaction-wiki).

        The settings are written as a YAML file.

        Can be used in combination with `settingsFiles` option, both will be present in the configuration directory.
      '';
      default = { };
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = { };
      };
    };

    settingsFiles = mkOption {
      description = ''
        Configuration for reaction, see the [wiki](https://framagit.org/ppom/reaction-wiki).

        reaction supports JSON, YAML and JSONnet. For those who prefer to take advantage of JSONnet rather than Nix.

        Can be used in combination with `settings` option, both will be present in the configuration directory.
      '';
      default = [ ];
      type = types.listOf types.path;
    };

    loglevel = mkOption {
      description = ''
        reaction's loglevel. One of DEBUG, INFO, WARN, ERROR.
      '';
      default = null;
      type = types.nullOr (
        types.enum [
          "DEBUG"
          "INFO"
          "WARN"
          "ERROR"
        ]
      );
    };

    stopForFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to stop reaction when reloading the firewall.

        The presence of a reaction chain in the INPUT table may cause the firewall
        reload to fail.
        One can alternatively cherry-pick the right iptables commands to execute before and after the firewall
        ```nix
        {
          systemd.services.firewall.serviceConfig = {
            ExecStopPre = [ "''${pkgs.iptables}/bin/iptables -w -D INPUT -p all -j reaction" ];
            ExecStartPost = [ "''${pkgs.iptables}/bin/iptables -w -I INPUT -p all -j reaction" ];
          };
        }
        ```
      '';
    };

    checkConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Check the syntax of the configuration files at build time";
    };

    runAsRoot = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to run reaction as root.
        Defaults to false, where an unprivileged reaction user is created.

        Be sure to give it sufficient permissions.
        Example config permitting `iptables` and `journalctl` use

        ```nix
        {
          # allows reading journal logs of processess
          users.users.reaction.extraGroups = [ "systemd-journal" ];
          # allows modifying ip firewall rules
          systemd.services.reaction.AmbientCapabilities = [ "CAP_NET_ADMIN" ];
          # optional, if more control over ssh logs is needed
          services.openssh.settings.LogLevel = lib.mkDefault "VERBOSE";
        }
        ```
      '';
    };
  };

  config =
    let
      cfg = config.services.reaction;

      generatedSettings = settingsFormat.generate "reaction.yml" cfg.settings;
      namedGeneratedSettings = lib.optional (cfg.settings != { }) {
        name = "reaction.yml";
        path = generatedSettings;
      };

      # SAFETY: We can discard the dependencies of "file" in the name attribute because we keep them in the path attribute
      # See https://nix.dev/manual/nix/2.32/language/string-context
      namedSettingsFiles = builtins.map (file: {
        name = builtins.unsafeDiscardStringContext (builtins.baseNameOf file);
        path = file;
      }) cfg.settingsFiles;

      settingsDir = pkgs.linkFarm "reaction.d" (namedSettingsFiles ++ namedGeneratedSettings);
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.settings != { } || (builtins.length cfg.settingsFiles) != 0;
          message = "You must specify settings and/or settingsFile options";
        }
      ];

      users = lib.mkIf (!cfg.runAsRoot) {
        users.reaction = {
          isSystemUser = true;
          group = "reaction";
        };
        groups.reaction = { };
      };

      system.checks =
        lib.optional (cfg.checkConfig && pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform)
          (
            pkgs.runCommand "reaction-config-validation" { } ''
              ${lib.getExe cfg.package} test-config -c ${settingsDir} >/dev/null
              echo "reaction config ${settingsDir} is valid"
              touch $out
            ''
          );

      # Easier to debug conf when we have direct access to it,
      # rather than having to look for it in the systemd service file.
      environment.etc."reaction".source = settingsDir;

      systemd.services.reaction = {
        enable = true;
        description = "Scan logs and take action";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        partOf = lib.optionals cfg.stopForFirewall [ "firewall.service" ];
        path = [ pkgs.iptables ];
        unitConfig.ConditionCapability = "CAP_NET_ADMIN";
        serviceConfig = {
          Type = "simple";
          User = if (!cfg.runAsRoot) then "reaction" else "root";
          ExecStart = ''
            ${lib.getExe cfg.package} start -c ${settingsDir}${
              lib.optionalString (cfg.loglevel != null) " -l ${cfg.loglevel}"
            }
          '';
          StateDirectory = "reaction";
          RuntimeDirectory = "reaction";
          WorkingDirectory = "/var/lib/reaction";

          CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
        };
      };

      environment.systemPackages = [ cfg.package ];
    };

  meta.maintainers =
    with lib.maintainers;
    [
      ppom
      phanirithvij
    ]
    ++ lib.teams.ngi.members;
}
