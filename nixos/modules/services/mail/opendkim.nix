{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.opendkim;

  defaultSock = "local:/run/opendkim/opendkim.sock";

  args = [ "-f" "-l"
           "-p" cfg.socket
           "-d" cfg.domains
           "-k" cfg.keyFile
           "-s" cfg.selector
         ] ++ optionals (cfg.configFile != null) [ "-x" cfg.configFile ];

in {

  ###### interface

  options = {

    services.opendkim = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the OpenDKIM sender authentication system.";
      };

      socket = mkOption {
        type = types.str;
        default = defaultSock;
        description = "Socket which is used for communication with OpenDKIM.";
      };

      user = mkOption {
        type = types.str;
        default = "opendkim";
        description = "User for the daemon.";
      };

      group = mkOption {
        type = types.str;
        default = "opendkim";
        description = "Group for the daemon.";
      };

      domains = mkOption {
        type = types.str;
        default = "csl:${config.networking.hostName}";
        example = "csl:example.com,mydomain.net";
        description = ''
          Local domains set (see <literal>opendkim(8)</literal> for more information on datasets).
          Messages from them are signed, not verified.
        '';
      };

      keyFile = mkOption {
        type = types.path;
        description = "Secret key file used for signing messages.";
      };

      selector = mkOption {
        type = types.str;
        description = "Selector to use when signing.";
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Additional opendkim configuration.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = optionalAttrs (cfg.user == "opendkim") (singleton
      { name = "opendkim";
        group = cfg.group;
        uid = config.ids.uids.opendkim;
      });

    users.extraGroups = optionalAttrs (cfg.group == "opendkim") (singleton
      { name = "opendkim";
        gid = config.ids.gids.opendkim;
      });

    environment.systemPackages = [ pkgs.opendkim ];

    systemd.services.opendkim = {
      description = "OpenDKIM signing and verification daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.opendkim}/bin/opendkim ${concatMapStringsSep " " escapeShellArg args}";
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = optional (cfg.socket == defaultSock) "opendkim";
      };
    };

  };
}
