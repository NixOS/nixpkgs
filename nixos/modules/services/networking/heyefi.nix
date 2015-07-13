{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.heyefi;
in

{

  ###### interface

  options = {

    services.heyefi = {

      cardMacaddress = mkOption {
        default = "";
        description = ''
          An Eye-Fi card MAC address.
          '';
      };

      uploadKey = mkOption {
        default = "";
        description = ''
          An Eye-Fi card's upload key.
          '';
      };

      uploadDir = mkOption {
        example = /home/ryantm/picture;
        description = ''
          The directory to upload the files to.
          '';
      };

      enable = mkOption {
        default = false;
        description = ''
          Enable heyefi, an Eye-Fi upload server.
        '';
      };

      user = mkOption {
        default = "root";
        description = ''
          heyefi will be run under this user (user must exist,
          this can be your user name).
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.heyefi =
      {
        description = "heyefi service";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "${cfg.user}";
          Restart = "always";
          ExecStart = "${pkgs.heyefi}/bin/heyefi";
        };

      };

    environment.etc."heyefi/heyefi.config".text =
      ''
        # /etc/heyefi/heyefi.conf: DO NOT EDIT -- this file has been generated automatically.
        cards = [["${config.services.heyefi.cardMacaddress}","${config.services.heyefi.uploadKey}"]]
        upload_dir = "${toString config.services.heyefi.uploadDir}"
      '';

    environment.systemPackages = [ pkgs.heyefi ];

  };

}
