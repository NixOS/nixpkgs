{ config, lib, pkgs, utils, ... }:

let
  # The scripted initrd contains some magic to add the prefix to the
  # paths just in time, so we don't add it here.
  sysrootPrefix = fs:
    if config.boot.initrd.systemd.enable && (utils.fsNeededForBoot fs) then
      "/sysroot"
    else
      "";

  # Returns a service that creates the required directories before the mount is
  # created.
  preMountService = _name: fs:
    let
      prefix = sysrootPrefix fs;

      escapedMountpoint = utils.escapeSystemdPath (prefix + fs.mountPoint);
      mountUnit = "${escapedMountpoint}.mount";

      upperdir = prefix + fs.overlay.upperdir;
      workdir = prefix + fs.overlay.workdir;
    in
    lib.mkIf (fs.overlay.upperdir != null)
      {
        "rw-${escapedMountpoint}" = {
          requiredBy = [ mountUnit ];
          before = [ mountUnit ];
          unitConfig = {
            DefaultDependencies = false;
            RequiresMountsFor = "${upperdir} ${workdir}";
          };
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.coreutils}/bin/mkdir -p -m 0755 ${upperdir} ${workdir}";
          };
        };
      };

  overlayOpts = { config, ... }: {

    options.overlay = {

      lowerdir = lib.mkOption {
        type = with lib.types; nullOr (nonEmptyListOf (either str pathInStore));
        default = null;
        description = ''
          The list of path(s) to the lowerdir(s).

          To create a writable overlay, you MUST provide an upperdir and a
          workdir.

          You can create a read-only overlay when you provide multiple (at
          least 2!) lowerdirs and neither an upperdir nor a workdir.
        '';
      };

      upperdir = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The path to the upperdir.

          If this is null, a read-only overlay is created using the lowerdir.

          If you set this to some value you MUST also set `workdir`.
        '';
      };

      workdir = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The path to the workdir.

          This MUST be set if you set `upperdir`.
        '';
      };

    };

    config = lib.mkIf (config.overlay.lowerdir != null) {
      fsType = "overlay";
      device = lib.mkDefault "overlay";

      options =
        let
          prefix = sysrootPrefix config;

          lowerdir = map (s: prefix + s) config.overlay.lowerdir;
          upperdir = prefix + config.overlay.upperdir;
          workdir = prefix + config.overlay.workdir;
        in
        [
          "lowerdir=${lib.concatStringsSep ":" lowerdir}"
        ] ++ lib.optionals (config.overlay.upperdir != null) [
          "upperdir=${upperdir}"
          "workdir=${workdir}"
        ] ++ (map (s: "x-systemd.requires-mounts-for=${s}") lowerdir);
    };

  };
in

{

  options = {

    # Merge the overlay options into the fileSystems option.
    fileSystems = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule [ overlayOpts ]);
    };

  };

  config =
    let
      overlayFileSystems = lib.filterAttrs (_name: fs: (fs.overlay.lowerdir != null)) config.fileSystems;
      initrdFileSystems = lib.filterAttrs (_name: utils.fsNeededForBoot) overlayFileSystems;
      userspaceFileSystems = lib.filterAttrs (_name: fs: (!utils.fsNeededForBoot fs)) overlayFileSystems;
    in
    {

      boot.initrd.availableKernelModules = lib.mkIf (initrdFileSystems != { }) [ "overlay" ];

      assertions = lib.concatLists (lib.mapAttrsToList
        (_name: fs: [
          {
            assertion = (fs.overlay.upperdir == null) == (fs.overlay.workdir == null);
            message = "You cannot define a `lowerdir` without a `workdir` and vice versa for mount point: ${fs.mountPoint}";
          }
          {
            assertion = (fs.overlay.lowerdir != null && fs.overlay.upperdir == null) -> (lib.length fs.overlay.lowerdir) >= 2;
            message = "A read-only overlay (without an `upperdir`) requires at least 2 `lowerdir`s: ${fs.mountPoint}";
          }
        ])
        config.fileSystems);

      boot.initrd.systemd.services = lib.mkMerge (lib.mapAttrsToList preMountService initrdFileSystems);
      systemd.services = lib.mkMerge (lib.mapAttrsToList preMountService userspaceFileSystems);

    };

}
