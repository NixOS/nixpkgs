{ pkgs, config, lib, ... }:

let
  cfg = config.services.envfs;
  mounts = {
    "/usr/bin" = {
      device = "none";
      fsType = "envfs";
      options = [
        "fallback-path=${pkgs.runCommand "fallback-path" {} (''
          mkdir -p $out
          ln -s ${config.environment.usrbinenv} $out/env
          ln -s ${config.environment.binsh} $out/sh
        '' + cfg.extraFallbackPathCommands)}"
      ];
    };
    "/bin" = {
      device = "/usr/bin";
      fsType = "none";
      options = [ "bind" ];
    };
  };
in {
  options = {
    services.envfs = {
      enable = lib.mkEnableOption (lib.mdDoc "Envfs filesystem") // {
        description = lib.mdDoc ''
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
        description = lib.mdDoc "Which package to use for the envfs.";
      };

      extraFallbackPathCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "ln -s $''{pkgs.bash}/bin/bash $out/bash";
        description = lib.mdDoc "Extra commands to run in the package that contains fallback executables in case not other executable is found";
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
  };
}
