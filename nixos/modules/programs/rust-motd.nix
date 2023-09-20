{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.rust-motd;
  format = pkgs.formats.toml { };

  orderedSections = listToAttrs
    (imap0
      (i: items@{ sectionHeader, ... }: nameValuePair "env${toString i}" {
        ${sectionHeader} = removeAttrs items [ "priority" "sectionHeader" ];
      })
      (sortProperties (mapAttrsToList (k: v: v // { sectionHeader = k; }) cfg.settings)));

  # Order the sections in the TOML according to the `priority` field.
  # This is done by
  # * creating an attribute set with keys `env0`/`env1`/.../`envN`
  #   where `env0` contains the first section and `envN` the last
  #   (in the form of `{ sectionName = { /* ... */ }}`)
  # * the declarations of `env0` to `envN` in ascending order are
  #   concatenated with `jq`. Now we have a JSON representation of
  #   the config in the correct order.
  # * this is piped to `json2toml` to get the correct format for rust-motd.
  motdConf = pkgs.runCommand "motd.conf"
    (orderedSections // {
      __structuredAttrs = true;
      nativeBuildInputs = [ pkgs.remarshal pkgs.jq ];
    })
    ''
      cat "$NIX_ATTRS_JSON_FILE" \
        | jq '${concatMapStringsSep " + " (key: ''."${key}"'') (attrNames orderedSections)}' \
        | json2toml /dev/stdin "$out"
    '';
in {
  options.programs.rust-motd = {
    enable = mkEnableOption (lib.mdDoc "rust-motd");
    enableMotdInSSHD = mkOption {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether to let `openssh` print the
        result when entering a new `ssh`-session.
        By default either nothing or a static file defined via
        [](#opt-users.motd) is printed. Because of that,
        the latter option is incompatible with this module.
      '';
    };
    refreshInterval = mkOption {
      default = "*:0/5";
      type = types.str;
      description = mdDoc ''
        Interval in which the {manpage}`motd(5)` file is refreshed.
        For possible formats, please refer to {manpage}`systemd.time(7)`.
      '';
    };
    settings = mkOption {
      type = types.attrsOf (types.submodule {
        freeformType = format.type;
        options.priority = mkOption {
          type = types.int;
          default = modules.defaultOrderPriority;
          description = mdDoc ''
            In `rust-motd`, the order of the sections in TOML correlates to the order
            of the items displayed in the resulting `motd`. Attributes in Nix are
            ordered alphabetically, e.g. `banner` would always be before `uptime`.

            To change that, this option can be used. The lower this number is, the higher
            is the priority and the more a section is at the top of the message.

            For instance

            ```nix
            {
              banner.command = "hostname | figlet -f slant";
              uptime = {
                prefix = "Up";
                priority = 0;
              };
            }
            ```

            would make the `uptime` appear before the banner.
          '';
        };
      });
      description = mdDoc ''
        Settings on what to generate. Please read the
        [upstream documentation](https://github.com/rust-motd/rust-motd/blob/main/README.md#configuration)
        for further information.
      '';
    };
  };
  config = mkIf cfg.enable {
    assertions = [
      { assertion = config.users.motd == null;
        message = ''
          `programs.rust-motd` is incompatible with `users.motd`!
        '';
      }
    ];
    systemd.services.rust-motd = {
      path = with pkgs; [ bash ];
      documentation = [ "https://github.com/rust-motd/rust-motd/blob/v${pkgs.rust-motd.version}/README.md" ];
      description = "motd generator";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.writeShellScript "update-motd" ''
          ${pkgs.rust-motd}/bin/rust-motd ${motdConf} > motd
        ''}";
        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        ProtectSystem = "full";
        StateDirectory = "rust-motd";
        RestrictAddressFamilies = [ "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        WorkingDirectory = "/var/lib/rust-motd";
      };
    };
    systemd.timers.rust-motd = {
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.refreshInterval;
    };
    security.pam.services.sshd.text = mkIf cfg.enableMotdInSSHD (mkDefault (mkAfter ''
      session optional ${pkgs.pam}/lib/security/pam_motd.so motd=/var/lib/rust-motd/motd
    ''));
    services.openssh.extraConfig = mkIf (cfg.settings ? last_login && cfg.settings.last_login != {}) ''
      PrintLastLog no
    '';
  };
  meta.maintainers = with maintainers; [ ma27 ];
}
