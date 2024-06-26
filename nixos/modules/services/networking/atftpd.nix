# NixOS module for atftpd TFTP server

{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let

  cfg = config.services.atftpd;

in

{

  options = {

    services.atftpd = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable the atftpd TFTP server. By default, the server
          binds to address 0.0.0.0.
        '';
      };

      extraOptions = mkOption {
        default = [ ];
        type = types.listOf types.str;
        example = literalExpression ''
          [ "--bind-address 192.168.9.1"
            "--verbose=7"
          ]
        '';
        description = ''
          Extra command line arguments to pass to atftp.
        '';
      };

      root = mkOption {
        default = "/srv/tftp";
        type = types.path;
        description = ''
          Document root directory for the atftpd.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    systemd.services.atftpd = {
      description = "TFTP Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # runs as nobody
      serviceConfig.ExecStart = "${pkgs.atftp}/sbin/atftpd --daemon --no-fork ${lib.concatStringsSep " " cfg.extraOptions} ${cfg.root}";
    };

  };

}
