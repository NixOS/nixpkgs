{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.external;
in
{
  meta = {
    maintainers = with maintainers; [ cole-h grahamc ];
    # Don't edit the docbook xml directly, edit the md and generate it:
    # `pandoc external.md -t docbook --top-level-division=chapter --extract-media=media -f markdown+smart > external.xml`
    doc = ./external.xml;
  };

  options.boot.loader.external = {
    enable = mkEnableOption "use an external tool to install your bootloader";

    installHook = mkOption {
      type = with types; path;
      description = ''
        The full path to a program of your choosing which performs the bootloader installation process.

        The program will be called with an argument pointing to the output of the system's toplevel.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub.enable = mkDefault false;
      systemd-boot.enable = mkDefault false;
      supportsInitrdSecrets = false;
    };

    system.build.installBootLoader = cfg.installHook;
  };
}
