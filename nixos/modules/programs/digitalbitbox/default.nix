{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.digitalbitbox;
in

{
  options.programs.digitalbitbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Installs the Digital Bitbox application and enables the complementary hardware module.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.digitalbitbox;
      defaultText = "pkgs.digitalbitbox";
      description = "The Digital Bitbox package to use. This can be used to install a package with udev rules that differ from the defaults.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    hardware.digitalbitbox = {
      enable = true;
      package = cfg.package;
    };
  };

  meta = {
    doc = ./doc.xml;
    maintainers = with stdenv.lib.maintainers; [ vidbina ];
  };
}
