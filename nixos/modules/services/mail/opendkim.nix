{ config, lib, pkgs, ... }:
let

  cfg = config.services.opendkim;

  defaultSock = "local:/run/opendkim/opendkim.sock";

  keyFile = "${cfg.keyPath}/${cfg.selector}.private";

  args = [ "-f" "-l"
           "-p" cfg.socket
           "-d" cfg.domains
           "-k" keyFile
           "-s" cfg.selector
         ] ++ lib.optionals (cfg.configFile != null) [ "-x" cfg.configFile ];

in {
  imports = [
    (lib.mkRenamedOptionModule [ "services" "opendkim" "keyFile" ] [ "services" "opendkim" "keyPath" ])
  ];

  ###### interface

  options = {

    services.opendkim = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the OpenDKIM sender authentication system.";
      };

      socket = lib.mkOption {
        type = lib.types.str;
        default = defaultSock;
        description = "Socket which is used for communication with OpenDKIM.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "opendkim";
        description = "User for the daemon.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "opendkim";
        description = "Group for the daemon.";
      };

      domains = lib.mkOption {
        type = lib.types.str;
        default = "csl:${config.networking.hostName}";
        defaultText = lib.literalExpression ''"csl:''${config.networking.hostName}"'';
        example = "csl:example.com,mydomain.net";
        description = ''
          Local domains set (see `opendkim(8)` for more information on datasets).
          Messages from them are signed, not verified.
        '';
      };

      keyPath = lib.mkOption {
        type = lib.types.path;
        description = ''
          The path that opendkim should put its generated private keys into.
          The DNS settings will be found in this directory with the name selector.txt.
        '';
        default = "/var/lib/opendkim/keys";
      };

      selector = lib.mkOption {
        type = lib.types.str;
        description = "Selector to use when signing.";
      };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Additional opendkim configuration.";
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    users.users = lib.optionalAttrs (cfg.user == "opendkim") {
      opendkim = {
        group = cfg.group;
        uid = config.ids.uids.opendkim;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "opendkim") {
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
        ExecStart = "${pkgs.opendkim}/bin/opendkim ${lib.escapeShellArgs args}";
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = lib.optional (cfg.socket == defaultSock) "opendkim";
        StateDirectory = "opendkim";
        StateDirectoryMode = "0700";
        ReadWritePaths = [ cfg.keyPath ];

        AmbientCapabilities = [];
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6 AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged @resources" ];
        UMask = "0077";
      };
    };

  };
}
