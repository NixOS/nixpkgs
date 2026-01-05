{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.systemd.sysupdate;

  format = pkgs.formats.ini { listToValue = toString; };

  # TODO: Switch back to using utils.systemdUtils.lib.definitions once
  # https://github.com/systemd/systemd/pull/38187 is resolved. Also ensure
  # utils.systemdUtils.lib.definitions is capable of setting a custom file
  # suffix.
  sysupdateTransfers = lib.mapAttrs' (name: value: {
    name = "sysupdate.d/${name}.transfer";
    value.source = format.generate "${name}.transfer" value;
  }) cfg.transfers;
in
{
  options.systemd.sysupdate = {

    enable = lib.mkEnableOption "systemd-sysupdate" // {
      description = ''
        Atomically update the host OS, container images, portable service
        images or other sources.

        If enabled, updates are triggered in regular intervals via a
        `systemd.timer` unit.

        Please see {manpage}`systemd-sysupdate(8)` for more details.
      '';
    };

    timerConfig = utils.systemdUtils.unitOptions.timerOptions.options.timerConfig // {
      default = { };
      description = ''
        The timer configuration for performing the update.

        By default, the upstream configuration is used:
        <https://github.com/systemd/systemd/blob/main/units/systemd-sysupdate.timer>
      '';
    };

    reboot = {
      enable = lib.mkEnableOption "automatically rebooting after an update" // {
        description = ''
          Whether to automatically reboot after an update.

          If set to `true`, the system will automatically reboot via a
          `systemd.timer` unit but only after a new version was installed.

          This uses a unit completely separate from the one performing the
          update because it is typically advisable to download updates
          regularly while the system is up, but delay reboots until the
          appropriate time (i.e. typically at night).

          Set this to `false` if you do not want to reboot after an update. This
          is useful when you update a container image or another source where
          rebooting is not necessary in order to finalize the update.
        '';
      };

      timerConfig = utils.systemdUtils.unitOptions.timerOptions.options.timerConfig // {
        default = { };
        description = ''
          The timer configuration for rebooting after an update.

          By default, the upstream configuration is used:
          <https://github.com/systemd/systemd/blob/main/units/systemd-sysupdate-reboot.timer>
        '';
      };
    };

    transfers = lib.mkOption {
      type = with lib.types; attrsOf format.type;
      default = { };
      example = {
        "10-uki" = {
          Transfer = {
            ProtectVersion = "%A";
          };

          Source = {
            Type = "url-file";
            Path = "https://download.example.com/";
            MatchPattern = [
              "nixos_@v+@l-@d.efi"
              "nixos_@v+@l.efi"
              "nixos_@v.efi"
            ];
          };

          Target = {
            Type = "regular-file";
            Path = "/EFI/Linux";
            PathRelativeTo = "boot";
            MatchPattern = ''
              nixos_@v+@l-@d.efi"; \
              nixos_@v+@l.efi \
              nixos_@v.efi
            '';
            Mode = "0444";
            TriesLeft = 3;
            TriesDone = 0;
            InstancesMax = 2;
          };
        };
      };
      description = ''
        Specify transfers as a set of the names of the transfer files as the
        key and the configuration as its value. The configuration can use all
        upstream options. See {manpage}`sysupdate.d(5)`
        for all available options.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.systemd.package.withSysupdate;
        message = "Cannot enable systemd-sysupdate with systemd package not built with sysupdate support";
      }
    ];

    systemd.additionalUpstreamSystemUnits = [
      "systemd-sysupdate.service"
      "systemd-sysupdate.timer"
      "systemd-sysupdate-reboot.service"
      "systemd-sysupdate-reboot.timer"
      "systemd-sysupdated.service"
    ];

    systemd.services.systemd-sysupdated.aliases = [ "dbus-org.freedesktop.sysupdate1.service" ];

    systemd.timers = {
      "systemd-sysupdate" = {
        wantedBy = [ "timers.target" ];
        timerConfig = cfg.timerConfig;
      };
      "systemd-sysupdate-reboot" = lib.mkIf cfg.reboot.enable {
        wantedBy = [ "timers.target" ];
        timerConfig = cfg.reboot.timerConfig;
      };
    };

    environment.etc = sysupdateTransfers;
  };

  meta.maintainers = with lib.maintainers; [
    nikstur
    jmbaur
  ];
}
