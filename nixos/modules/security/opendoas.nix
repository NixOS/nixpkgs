{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.opendoas;

  inherit (pkgs) opendoas;

in

{

  ###### interface

  options = {

    security.opendoas.enable = mkOption {
      type = types.bool;
      default = true;
      description =
        ''
          Whether to enable the <command>doas</command> command, which
          allows non-root users to execute commands as root.
        '';
    };

    security.opendoas.configFile = mkOption {
      type = types.lines;
      # Note: if syntax errors are detected in this file, the NixOS
      # configuration will fail to build.
      description =
        ''
          This string contains the contents of the
          <filename>doas.conf</filename> file.
        '';
    };

    security.opendoas.extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra configuration text appended to <filename>doas.conf</filename>.
      '';
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    security.opendoas.configFile =
      ''
        # Don't edit this file. Set the NixOS options ‘security.opendoas.configFile’
        # or ‘security.opendoas.extraConfig’ instead.

        ${cfg.extraConfig}
      '';

    security.setuidPrograms = [ "doas" ];

    environment.systemPackages = [ opendoas ];
  };

}
