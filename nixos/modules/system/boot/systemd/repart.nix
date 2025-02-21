{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.systemd.repart;
  initrdCfg = config.boot.initrd.systemd.repart;

  format = pkgs.formats.ini { };

  definitionsDirectory = utils.systemdUtils.lib.definitions "repart.d" format (
    lib.mapAttrs (_n: v: { Partition = v; }) cfg.partitions
  );

  partitionAssertions = lib.mapAttrsToList (
    fileName: definition:
    let
      inherit (utils.systemdUtils.lib) GPTMaxLabelLength;
      labelLength = builtins.stringLength definition.Label;
    in
    {
      assertion = definition ? Label -> GPTMaxLabelLength >= labelLength;
      message = ''
        The partition label '${definition.Label}' defined for '${fileName}' is ${toString labelLength}
        characters long, but the maximum label length supported by systemd is ${toString GPTMaxLabelLength}.
      '';
    }
  ) cfg.partitions;
in
{
  options = {
    boot.initrd.systemd.repart = {
      enable = lib.mkEnableOption "systemd-repart" // {
        description = ''
          Grow and add partitions to a partition table at boot time in the initrd.
          systemd-repart only works with GPT partition tables.

          To run systemd-repart after the initrd, see
          `options.systemd.repart.enable`.
        '';
      };

      device = lib.mkOption {
        type = with lib.types; nullOr str;
        description = ''
          The device to operate on.

          If `device == null`, systemd-repart will operate on the device
          backing the root partition. So in order to dynamically *create* the
          root partition in the initrd you need to set a device.
        '';
        default = null;
        example = "/dev/vda";
      };

      empty = lib.mkOption {
        type = lib.types.enum [
          "refuse"
          "allow"
          "require"
          "force"
          "create"
        ];
        description = ''
          Controls how to operate on empty devices that contain no partition table yet.
          See {manpage}`systemd-repart(8)` for details.
        '';
        example = "require";
        default = "refuse";
      };
    };

    systemd.repart = {
      enable = lib.mkEnableOption "systemd-repart" // {
        description = ''
          Grow and add partitions to a partition table.
          systemd-repart only works with GPT partition tables.

          To run systemd-repart while in the initrd, see
          `options.boot.initrd.systemd.repart.enable`.
        '';
      };

      partitions = lib.mkOption {
        type =
          with lib.types;
          attrsOf (
            attrsOf (oneOf [
              str
              int
              bool
            ])
          );
        default = { };
        example = {
          "10-root" = {
            Type = "root";
          };
          "20-home" = {
            Type = "home";
            SizeMinBytes = "512M";
            SizeMaxBytes = "2G";
          };
        };
        description = ''
          Specify partitions as a set of the names of the definition files as the
          key and the partition configuration as its value. The partition
          configuration can use all upstream options. See {manpage}`repart.d(5)`
          for all available options.
        '';
      };
    };
  };

  config = lib.mkIf (cfg.enable || initrdCfg.enable) {
    assertions = [
      {
        assertion = initrdCfg.enable -> config.boot.initrd.systemd.enable;
        message = ''
          'boot.initrd.systemd.repart.enable' requires 'boot.initrd.systemd.enable' to be enabled.
        '';
      }
    ] ++ partitionAssertions;

    # systemd-repart uses loopback devices for partition creation
    boot.initrd.availableKernelModules = lib.optional initrdCfg.enable "loop";

    boot.initrd.systemd = lib.mkIf initrdCfg.enable {
      additionalUpstreamUnits = [
        "systemd-repart.service"
      ];

      storePaths = [
        "${config.boot.initrd.systemd.package}/bin/systemd-repart"
      ];

      contents."/etc/repart.d".source = definitionsDirectory;

      # Override defaults in upstream unit.
      services.systemd-repart =
        let
          deviceUnit = "${utils.escapeSystemdPath initrdCfg.device}.device";
        in
        {
          # systemd-repart tries to create directories in /var/tmp by default to
          # store large temporary files that benefit from persistence on disk. In
          # the initrd, however, /var/tmp does not provide more persistence than
          # /tmp, so we re-use it here.
          environment."TMPDIR" = "/tmp";
          serviceConfig = {
            ExecStart = [
              " " # required to unset the previous value.
              # When running in the initrd, systemd-repart by default searches
              # for definition files in /sysroot or /sysusr. We tell it to look
              # in the initrd itself.
              ''
                ${config.boot.initrd.systemd.package}/bin/systemd-repart \
                                  --definitions=/etc/repart.d \
                                  --dry-run=no \
                                  --empty=${initrdCfg.empty} \
                                  ${lib.optionalString (initrdCfg.device != null) initrdCfg.device}
              ''
            ];
          };
          # systemd-repart needs to run after /sysroot (or /sysuser, but we
          # don't have it) has been mounted because otherwise it cannot
          # determine the device (i.e disk) to operate on. If you want to run
          # systemd-repart without /sysroot (i.e. to create the root
          # partition), you have to explicitly tell it which device to operate
          # on. The service then needs to be ordered to run after this device
          # is available.
          requires = lib.mkIf (initrdCfg.device != null) [ deviceUnit ];
          after = if initrdCfg.device == null then [ "sysroot.mount" ] else [ deviceUnit ];
        };
    };

    environment.etc = lib.mkIf cfg.enable {
      "repart.d".source = definitionsDirectory;
    };

    systemd = lib.mkIf cfg.enable {
      additionalUpstreamSystemUnits = [
        "systemd-repart.service"
      ];
    };
  };

  meta.maintainers = with lib.maintainers; [ nikstur ];
}
