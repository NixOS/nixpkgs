{
  lib,
  pkgs,
  config,
  ...
}:
let
  settingsFormat = pkgs.formats.yaml { };

  cfg = config.services.reaction;

  inherit (lib)
    concatMapStringsSep
    filterAttrs
    getExe
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mapAttrs
    optional
    optionals
    optionalString
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
        options = {
          plugins = mkOption {
            description = ''
              Nixpkgs provides a `reaction-plugins` package set which includes both offical and community plugins for reaction.

              To use the plugins in your module configuration, in `settings.plugins` you can use for e.g. `''${lib.getExe reaction-plugins.reaction-plugin-ipset}`
              See https://reaction.ppom.me/plugins/ to configure plugins.
            '';
            default = { };
            type = types.attrsOf (
              types.submodule (
                { name, ... }:
                {
                  options = {
                    enable = mkOption {
                      description = "enable reaction-plugin-${name}";
                      type = types.bool;
                      default = true;
                    };
                    path = mkOption {
                      description = "path to the plugin binary";
                      type = types.str;
                      default = "${cfg.package.plugins."reaction-plugin-${name}"}/bin/reaction-plugin-${name}";
                      defaultText = lib.literalExpression ''''${cfg.package.plugins."reaction-plugin-${name}"}/bin/reaction-plugin-${name}'';
                    };
                    check_root = mkOption {
                      description = "Whether reaction must check that the executable is owned by root";
                      type = types.bool;
                      default = true;
                    };
                    systemd = mkOption {
                      description = "Whether reaction must isolate the plugin using systemd's run0";
                      type = types.bool;
                      default = cfg.runAsRoot;
                      defaultText = "config.services.reaction.runAsRoot";
                    };
                    systemd_options = mkOption {
                      description = ''
                        A key-value map of systemd options.
                        Keys must be strings and values must be string arrays.

                        See `man systemd.directives` for all supported options, and particularly options in `man systemd.exec`
                      '';
                      type = types.attrsOf (types.listOf types.str);
                      default = { };
                    };
                  };
                }
              )
            );
            # Filter plugins which are disabled
            apply =
              self:
              lib.pipe self [
                (filterAttrs (name: p: p.enable))
                (mapAttrs (name: p: removeAttrs p [ "enable" ]))
              ];
          };
        };
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
          systemd.services.reaction.unitConfig.ConditionCapability = "CAP_NET_ADMIN";
          systemd.services.reaction.serviceConfig = {
            CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
            AmbientCapabilities = [ "CAP_NET_ADMIN" ];
          };

          # optional, if more control over ssh logs is needed
          services.openssh.settings.LogLevel = lib.mkDefault "VERBOSE";
        }
        ```

        ```nix
        # core ipset plugin requires these if running as non-root
        systemd.services.reaction.serviceConfig = {
          CapabilityBoundingSet = [
            "CAP_NET_ADMIN"
            "CAP_NET_RAW"
            "CAP_DAC_READ_SEARCH" # for journalctl
          ];
          AmbientCapabilities = [
            "CAP_NET_ADMIN"
            "CAP_NET_RAW"
            "CAP_DAC_READ_SEARCH"
          ];
        };
        ```
      '';
    };
  };

  config =
    let
      generatedSettings = settingsFormat.generate "reaction.yml" cfg.settings;
      settingsDir = pkgs.runCommand "reaction-settings-dir" { } ''
        mkdir -p $out
        ${concatMapStringsSep "\n" (file: ''
          filename=$(basename "${file}")
          ln -s "${file}" "$out/$filename"
        '') cfg.settingsFiles}
        ln -s ${generatedSettings} $out/reaction.yml
      '';
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.settings != { } || (builtins.length cfg.settingsFiles) != 0;
          message = "You must specify settings and/or settingsFile options";
        }
      ];

      users = mkIf (!cfg.runAsRoot) {
        users.reaction = {
          isSystemUser = true;
          group = "reaction";
        };
        groups.reaction = { };
      };

      system.checks =
        optional (cfg.checkConfig && pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform)
          (
            pkgs.runCommand "reaction-config-validation" { } ''
              ${getExe cfg.package} test-config -c ${settingsDir} >/dev/null
              echo "reaction config ${settingsDir} is valid"
              touch $out
            ''
          );

      systemd.services.reaction = {
        description = "A daemon that scans program outputs for repeated patterns, and takes action.";
        documentation = [ "https://reaction.ppom.me" ];
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        partOf = optionals cfg.stopForFirewall [ "firewall.service" ];
        path = [ pkgs.iptables ];
        serviceConfig = {
          Type = "simple";
          KillMode = "mixed"; # for plugins
          User = if (!cfg.runAsRoot) then "reaction" else "root";
          ExecStart = ''
            ${getExe cfg.package} start -c ${settingsDir}${
              optionalString (cfg.loglevel != null) " -l ${cfg.loglevel}"
            }
          '';

          NoNewPrivileges = true;

          RuntimeDirectory = "reaction";
          RuntimeDirectoryMode = "0750";
          WorkingDirectory = "%S/reaction";
          StateDirectory = "reaction";
          StateDirectoryMode = "0750";
          LogsDirectory = "reaction";
          LogsDirectoryMode = "0750";
          UMask = 0077;

          RemoveIPC = true;
          PrivateTmp = true;
          ProtectHome = true;
          ProtectClock = true;
          PrivateDevices = true;
          ProtectHostname = true;
          ProtectSystem = "strict";
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
        };
      };

      # pre-configure official plugins
      services.reaction.settings.plugins = {
        ipset = {
          enable = mkDefault true;
          systemd_options = {
            CapabilityBoundingSet = [
              "~CAP_NET_ADMIN"
              "~CAP_PERFMON"
            ];
          };
        };
        virtual.enable = mkDefault true;
      };

      environment.systemPackages = [ cfg.package ];
    };

  meta.maintainers =
    with lib.maintainers;
    [
      ppom
    ]
    ++ lib.teams.ngi.members;
}
