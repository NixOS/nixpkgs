{
  config,
  lib,
  ...
}:

let
  cfg = config.boot.loader.external;
in
{
  meta = {
    maintainers = with lib.maintainers; [
      cole-h
      grahamc
      raitobezarius
    ];
    doc = ./external.md;
  };

  options.boot.loader.external = {
    enable = lib.mkEnableOption "using an external tool to install your bootloader";

    installHook = lib.mkOption {
      type = lib.types.path;
      description = ''
        The full path to a program of your choosing which performs the bootloader installation process.

        The program will be called with an argument pointing to the output of the system's toplevel.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      grub.enable = lib.mkDefault false;
      systemd-boot.enable = lib.mkDefault false;
      supportsInitrdSecrets = lib.mkDefault false;
    };

    system.build.installBootLoader = cfg.installHook;
  };
}
