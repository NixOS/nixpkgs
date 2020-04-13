{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.opendkim;

  defaultSock = "local:/run/opendkim/opendkim.sock";

  keyFile = "${cfg.keyPath}/${cfg.selector}.private";

  args = [ "-f" "-l"
           "-p" cfg.socket
           "-d" cfg.domains
           "-k" keyFile
           "-s" cfg.selector
         ] ++ optionals (cfg.configFile != null) [ "-x" cfg.configFile ];

in {
  imports = [
    (mkRenamedOptionModule [ "services" "opendkim" "keyFile" ] [ "services" "opendkim" "keyPath" ])
  ];

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

      keyPath = mkOption {
        type = types.path;
        description = ''
          The path that opendkim should put its generated private keys into.
          The DNS settings will be found in this directory with the name selector.txt.
        '';
        default = "/var/lib/opendkim/keys";
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

    users.users = optionalAttrs (cfg.user == "opendkim") {
      opendkim = {
        group = cfg.group;
        uid = config.ids.uids.opendkim;
      };
    };

    users.groups = optionalAttrs (cfg.group == "opendkim") {
      opendkim.gid = config.ids.gids.opendkim;
    };

    environment.systemPackages = [ pkgs.opendkim ];

    systemd.tmpfiles.rules = [
      "d '${cfg.keyPath}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.opendkim = {
      description = "OpenDKIM signing and verification daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        cd "${cfg.keyPath}"
        if ! test -f ${cfg.selector}.private; then
          ${pkgs.opendkim}/bin/opendkim-genkey -s ${cfg.selector} -d all-domains-generic-key
          echo "Generated OpenDKIM key! Please update your DNS settings:\n"
          echo "-------------------------------------------------------------"
          cat ${cfg.selector}.txt
          echo "-------------------------------------------------------------"
        fi
      '';

      serviceConfig = {
        ExecStart = "${pkgs.opendkim}/bin/opendkim ${escapeShellArgs args}";
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = optional (cfg.socket == defaultSock) "opendkim";
      };
    };

  };
}
