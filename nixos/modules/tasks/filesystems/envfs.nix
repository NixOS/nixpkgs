{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.envfs;
  mounts = {
    "/usr/bin" = {
      device = "none";
      fsType = "envfs";
      options = [
        "bind-mount=/bin"
        "fallback-path=${
          pkgs.runCommand "fallback-path" { } (
            ''
              mkdir -p $out
              ln -s ${config.environment.usrbinenv} $out/env
              ln -s ${config.environment.binsh} $out/sh
            ''
            + cfg.extraFallbackPathCommands
          )
        }"
        "nofail"
      ];
    };
    # We need to bind-mount /bin to /usr/bin, because otherwise upgrading
    # from envfs < 1.0.5 will cause having the old envs with no /bin bind mount.
    # Systemd is smart enough to not mount /bin if it's already mounted.
    "/bin" = {
      device = "/usr/bin";
      fsType = "none";
      options = [
        "bind"
        "nofail"
      ];
    };
  };
in
{
  options = {
    services.envfs = {
      enable = lib.mkEnableOption "Envfs filesystem" // {
        description = ''
          Fuse filesystem that returns symlinks to executables based on the PATH
          of the requesting process. This is useful to execute shebangs on NixOS
          that assume hard coded locations in locations like /bin or /usr/bin
          etc.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.envfs;
        defaultText = lib.literalExpression "pkgs.envfs";
        description = "Which package to use for the envfs.";
      };

      extraFallbackPathCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "ln -s $''{pkgs.bash}/bin/bash $out/bash";
        description = "Extra commands to run in the package that contains fallback executables in case not other executable is found";
      };
    };
  };
  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = [ cfg.package ];
    # we also want these mounts in virtual machines.
    fileSystems = if config.virtualisation ? qemu then lib.mkVMOverride mounts else mounts;

    # We no longer need those when using envfs
    system.activationScripts.usrbinenv = lib.mkForce "";
    system.activationScripts.binsh = lib.mkForce "";

    # Disabling the activation scripts above prevents the creation of 2
    # directories, which would normally be created just before switch-root at
    # stage1. This causes problems when systemd is used in the initrd.
    #
    # This only affects fresh installations or systems using impermanence/tmpfs
    # root, where these directories don't persist from a previous activation.
    boot.initrd.systemd.tmpfiles.settings = lib.mkIf config.boot.initrd.systemd.enable {
      "50-envfs" = {
        # During switch-root, systemd's base_filesystem_create_fd() creates an
        # empty /usr. Later at stage2, systemd initialize_runtime() checks
        # dir_is_empty("/usr/"), which returns 1 for an empty but existing
        # directory causing a fatal boot failure: "Refusing to run in
        # unsupported environment where /usr/ is not populated."
        "/sysroot/usr/bin" = {
          d = {
            group = "root";
            mode = "0755";
            user = "root";
          };
        };
        # During switch-root, base_filesystem_create_fd() creates a symlink
        # /bin -> /usr/bin if /bin does not exist. systemd-fstab-generator then
        # canonicalizes the /bin fstab entry through this symlink, producing a
        # duplicate usr-bin.mount. Create /bin to avoid this behaviour.
        "/sysroot/bin" = {
          d = {
            group = "root";
            mode = "0755";
            user = "root";
          };
        };
      };
    };
  };
}
