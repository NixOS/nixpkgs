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
    fileSystems = if config.virtualisation.qemu ? package then lib.mkVMOverride mounts else mounts;

    # We no longer need those when using envfs. /bin is still made a symlink
    # to usr/bin by the bin activation script.
    system.activationScripts.usrbinenv = lib.mkForce "";
    system.activationScripts.binsh = lib.mkForce "";

    # Disabling the activation scripts above prevents the creation of
    # /usr/bin, which would normally be created just before switch-root at
    # stage1. This only affects fresh installations or systems using
    # impermanence/tmpfs root, where this directory doesn't persist from a
    # previous activation.
    boot.initrd.systemd.tmpfiles.settings = {
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
      };
    };
  };
}
