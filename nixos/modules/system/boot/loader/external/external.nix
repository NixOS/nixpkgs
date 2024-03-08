{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.external;
in
{
  meta = {
    maintainers = with maintainers; [ cole-h grahamc raitobezarius ];
    doc = ./external.md;
  };

  options.boot.loader.external = {
    enable = mkEnableOption (lib.mdDoc "using an external tool to install your bootloader");

    installHook = mkOption {
      type = with types; path;
      description = lib.mdDoc ''
        The full path to a program of your choosing which performs the bootloader installation process.

        The program will be called with an argument pointing to the output of the system's toplevel.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub.enable = mkDefault false;
      systemd-boot.enable = mkDefault false;
      supportsInitrdSecrets = mkDefault false;
    };

    system.build.installBootLoader = cfg.installHook;
  };
}
