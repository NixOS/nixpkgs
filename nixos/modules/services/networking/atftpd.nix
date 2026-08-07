# NixOS module for atftpd TFTP server
{
  config,
  pkgs,
  lib,
  ...
}:
let

  cfg = config.services.atftpd;

in

{

  options = {

    services.atftpd = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable the atftpd TFTP server. By default, the server
          binds to address 0.0.0.0.
        '';
      };

      extraOptions = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        example = lib.literalExpression ''
          [ "--bind-address 192.168.9.1"
            "--verbose=7"
          ]
        '';
        description = ''
          Extra command line arguments to pass to atftp.
        '';
      };

      root = lib.mkOption {
        default = "/srv/tftp";
        type = lib.types.path;
        description = ''
          Document root directory for the atftpd.
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.atftpd = {
      description = "TFTP Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # runs as nobody
      serviceConfig.ExecStart = "${pkgs.atftp}/sbin/atftpd --daemon --no-fork ${lib.concatStringsSep " " cfg.extraOptions} ${cfg.root}";
    };

  };

}
