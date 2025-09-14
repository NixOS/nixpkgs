{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.rust-motd;
  format = pkgs.formats.toml { };

  # Order the sections in the TOML according to the order of sections
  # in `cfg.order`.
  motdConf =
    pkgs.runCommand "motd.toml"
      {
        __structuredAttrs = true;
        inherit (cfg) order settings;
        nativeBuildInputs = [
          pkgs.remarshal
          pkgs.jq
        ];
      }
      ''
        cat "$NIX_ATTRS_JSON_FILE" \
          | jq '.settings as $settings
                | .order
                | map({ key: ., value: $settings."\(.)" })
                | from_entries' -r \
          | json2toml /dev/stdin "$out"
      '';
in
{
  options.programs.rust-motd = {
    enable = lib.mkEnableOption "rust-motd, a Message Of The Day (MOTD) generator";
    enableMotdInSSHD = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Whether to let `openssh` print the
        result when entering a new `ssh`-session.
        By default either nothing or a static file defined via
        [](#opt-users.motd) is printed. Because of that,
        the latter option is incompatible with this module.
      '';
    };
    refreshInterval = lib.mkOption {
      default = "*:0/5";
      type = lib.types.str;
      description = ''
        Interval in which the {manpage}`motd(5)` file is refreshed.
        For possible formats, please refer to {manpage}`systemd.time(7)`.
      '';
    };
    order = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = builtins.attrNames cfg.settings;
      defaultText = lib.literalExpression "attrNames cfg.settings";
      description = ''
        The order of the sections in [](#opt-programs.rust-motd.settings).
        By default they are ordered alphabetically.

        Context: since attribute sets in Nix are always
        ordered alphabetically internally this means that

        ```nix
        {
          uptime = { /* ... */ };
          banner = { /* ... */ };
        }
        ```

        will still have `banner` displayed before `uptime`.

        To work around that, this option can be used to define the order of all keys,
        i.e.

        ```nix
        {
          order = [
            "uptime"
            "banner"
          ];
        }
        ```

        makes sure that `uptime` is placed before `banner` in the motd.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.attrsOf format.type;
      description = ''
        Settings on what to generate. Please read the
        [upstream documentation](https://github.com/rust-motd/rust-motd/blob/main/README.md#configuration)
        for further information.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.users.motd == "";
        message = ''
          `programs.rust-motd` is incompatible with `users.motd`!
        '';
      }
      {
        assertion = builtins.sort (a: b: a < b) cfg.order == builtins.attrNames cfg.settings;
        message = ''
          Please ensure that every section from `programs.rust-motd.settings` is present in
          `programs.rust-motd.order`.
        '';
      }
    ];
    systemd.services.rust-motd = {
      path = with pkgs; [ bash ];
      documentation = [
        "https://github.com/rust-motd/rust-motd/blob/v${pkgs.rust-motd.version}/README.md"
      ];
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

    security.pam.services.sshd.showMotd = lib.mkIf cfg.enableMotdInSSHD true;
    users.motdFile = lib.mkIf cfg.enableMotdInSSHD "/var/lib/rust-motd/motd";

    programs.rust-motd.settings.global.show_legacy_warning = false;

    services.openssh.extraConfig =
      lib.mkIf (cfg.settings ? last_login && cfg.settings.last_login != { })
        ''
          PrintLastLog no
        '';
  };
  meta.maintainers = with lib.maintainers; [ ma27 ];
}
