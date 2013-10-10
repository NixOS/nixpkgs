{ pkgs, config, ... }:

with pkgs;
with pkgs.lib;

let

  cfg = config.services.opensmtpd;
  conf = writeText "smtpd.conf" cfg.serverConfiguration;
  args = concatStringsSep " " cfg.extraServerArgs;

in {

  ###### interface

  options = {

    services.opensmtpd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the OpenSMTPD server.";
      };

      extraServerArgs = mkOption {
        type = types.listOf types.string;
        default = [];
        example = [ "-v" "-P mta" ];
        description = ''
          Extra command line arguments provided when the smtpd process
          is started.
        '';
      };

      serverConfiguration = mkOption {
        type = types.string;
        default = "";
        example = ''
          listen on lo
          accept for any deliver to lmtp localhost:24
        ''; 
        description = ''
          The contents of the smtpd.conf configuration file. See the
          OpenSMTPD documentation for syntax information. If this option
          is left empty, the OpenSMTPD server will not start.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.opensmtpd.enable {
    users.extraGroups = {
      smtpd.gid = config.ids.gids.smtpd;
      smtpq.gid = config.ids.gids.smtpq;
    };

    users.extraUsers = {
      smtpd = {
        description = "OpenSMTPD process user";
        uid = config.ids.uids.smtpd;
        group = "smtpd";
      };
      smtpq = {
        description = "OpenSMTPD queue user";
        uid = config.ids.uids.smtpq;
        group = "smtpq";
      };
    };

    systemd.services.opensmtpd = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
      after = [ "network.target" ];
      preStart = "mkdir -p /var/spool";
      serviceConfig.ExecStart = "${opensmtpd}/sbin/smtpd -d -f ${conf} ${args}";
    };
  };
}
