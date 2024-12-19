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

  definitionsDirectory = utils.systemdUtils.lib.definitions "sysupdate.d" format cfg.transfers;
in
{
  options.systemd.sysupdate = {

    enable = lib.mkEnableOption "systemd-sysupdate" // {
      description = ''
        Atomically update the host OS, container images, portable service
        images or other sources.

        If enabled, updates are triggered in regular intervals via a
        `systemd.timer` unit.

        Please see
        <https://www.freedesktop.org/software/systemd/man/systemd-sysupdate.html>
        for more details.
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
        upstream options. See
        <https://www.freedesktop.org/software/systemd/man/sysupdate.d.html>
        for all available options.
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.additionalUpstreamSystemUnits = [
      "systemd-sysupdate.service"
      "systemd-sysupdate.timer"
      "systemd-sysupdate-reboot.service"
      "systemd-sysupdate-reboot.timer"
    ];

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

    environment.etc."sysupdate.d".source = definitionsDirectory;
  };

  meta.maintainers = with lib.maintainers; [ nikstur ];
}
