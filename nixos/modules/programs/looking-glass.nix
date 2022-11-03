{ config, pkgs, lib, ... }:

with lib;
let
  settingsFormat = pkgs.formats.ini { };
  cfg = config.programs.looking-glass;
in {
  options.programs.looking-glass = {
    enable = mkEnableOption "Module for installing and configuring <package>looking-glass-client</package>";
    package = mkOption {
      type = types.package;
      description = "The looking-glass-client package to install";
      default = pkgs.looking-glass-client;
      defaultText = "pkgs.looking-glass-client";
    };

    shm = {
      name = mkOption {
        type = types.str;
        description = "Name of shared memory file";
        default = "looking-glass";
      };
      user = mkOption {
        type = types.str;
        description = "User of shared memory file";
        default = "1000";
      };
      group = mkOption {
        type = types.str;
        description = "Group of shared memory file";
        default = "libvirtd";
      };
      permissions = mkOption {
        type = types.str;
        description = "Permission bits for shared memory file";
        default = "0660";
      };
    };

    settings = mkOption {
     description = ''
       Configuration for <package>looking-glass-client</package>.

       See <link xlink:href="https://looking-glass.io/docs/stable/install/#full-command-line-options">documentation</link> for list of supported options.
     '';
     type = settingsFormat.type;
     default = { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.tmpfiles.rules = with cfg.shm;
      [ "f /dev/shm/${name} ${permissions} ${user} ${group} -" ];

    environment.etc."looking-glass-client.ini".source = settingsFormat.generate "looking-glass-client.ini" cfg.settings;
  };

  meta.maintainers = with maintainers; [ babbaj ];
}
