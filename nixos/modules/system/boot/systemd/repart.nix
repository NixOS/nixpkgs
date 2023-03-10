{ config, pkgs, lib, ... }:

let
  cfg = config.systemd.repart;
  initrdCfg = config.boot.initrd.systemd.repart;

  writeDefinition = name: partitionConfig: pkgs.writeText
    "${name}.conf"
    (lib.generators.toINI { } { Partition = partitionConfig; });

  listOfDefinitions = lib.mapAttrsToList
    writeDefinition
    (lib.filterAttrs (k: _: !(lib.hasPrefix "_" k)) cfg.partitions);

  # Create a directory in the store that contains a copy of all definition
  # files. This is then passed to systemd-repart in the initrd so it can access
  # the definition files after the sysroot has been mounted but before
  # activation. This needs a hard copy of the files and not just symlinks
  # because otherwise the files do not show up in the sysroot.
  definitionsDirectory = pkgs.runCommand "systemd-repart-definitions" { } ''
    mkdir -p $out
    ${(lib.concatStringsSep "\n"
      (map (pkg: "cp ${pkg} $out/${pkg.name}") listOfDefinitions)
    )}
  '';
in
{
  options = {
    boot.initrd.systemd.repart.enable = lib.mkEnableOption (lib.mdDoc "systemd-repart") // {
      description = lib.mdDoc ''
        Grow and add partitions to a partition table at boot time in the initrd.
        systemd-repart only works with GPT partition tables.

        To run systemd-repart after the initrd, see
        `options.systemd.repart.enable`.
      '';
    };

    systemd.repart = {
      enable = lib.mkEnableOption (lib.mdDoc "systemd-repart") // {
        description = lib.mdDoc ''
          Grow and add partitions to a partition table.
          systemd-repart only works with GPT partition tables.

          To run systemd-repart while in the initrd, see
          `options.boot.initrd.systemd.repart.enable`.
        '';
      };

      partitions = lib.mkOption {
        type = with lib.types; attrsOf (attrsOf (oneOf [ str int bool ]));
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
        description = lib.mdDoc ''
          Specify partitions as a set of the names of the definition files as the
          key and the partition configuration as its value. The partition
          configuration can use all upstream options. See <link
          xlink:href="https://www.freedesktop.org/software/systemd/man/repart.d.html"/>
          for all available options.
        '';
      };
    };
  };

  config = lib.mkIf (cfg.enable || initrdCfg.enable) {
    # Always link the definitions into /etc so that they are also included in
    # the /nix/store of the sysroot during early userspace (i.e. while in the
    # initrd).
    environment.etc."repart.d".source = definitionsDirectory;

    boot.initrd.systemd = lib.mkIf initrdCfg.enable {
      additionalUpstreamUnits = [
        "systemd-repart.service"
      ];

      storePaths = [
        "${config.boot.initrd.systemd.package}/bin/systemd-repart"
      ];

      # Override defaults in upstream unit.
      services.systemd-repart = {
        # Unset the conditions as they cannot be met before activation because
        # the definition files are not stored in the expected locations.
        unitConfig.ConditionDirectoryNotEmpty = [
          " " # required to unset the previous value.
        ];
        serviceConfig = {
          # systemd-repart runs before the activation script. Thus we cannot
          # rely on them being linked in /etc already. Instead we have to
          # explicitly pass their location in the sysroot to the binary.
          ExecStart = [
            " " # required to unset the previous value.
            ''${config.boot.initrd.systemd.package}/bin/systemd-repart \
                  --definitions=/sysroot${definitionsDirectory} \
                  --dry-run=no
            ''
          ];
        };
        # Because the initrd does not have the `initrd-usr-fs.target` the
        # upestream unit runs too early in the boot process, before the sysroot
        # is available. However, systemd-repart needs access to the sysroot to
        # find the definition files.
        after = [ "sysroot.mount" ];
      };
    };

    systemd = lib.mkIf cfg.enable {
      additionalUpstreamSystemUnits = [
        "systemd-repart.service"
      ];
    };
  };

}
