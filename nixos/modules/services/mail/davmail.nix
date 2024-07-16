{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.davmail;

  configType = with types;
    oneOf [ (attrsOf configType) str int bool ] // {
      description = "davmail config type (str, int, bool or attribute set thereof)";
    };

  toStr = val: if isBool val then boolToString val else toString val;

  linesForAttrs = attrs: concatMap (name: let value = attrs.${name}; in
    if isAttrs value
      then map (line: name + "." + line) (linesForAttrs value)
      else [ "${name}=${toStr value}" ]
  ) (attrNames attrs);

  configFile = pkgs.writeText "davmail.properties" (concatStringsSep "\n" (linesForAttrs cfg.config));

in

  {
    options.services.davmail = {
      enable = mkEnableOption "davmail, an MS Exchange gateway";

      url = mkOption {
        type = types.str;
        description = "Outlook Web Access URL to access the exchange server, i.e. the base webmail URL.";
        example = "https://outlook.office365.com/EWS/Exchange.asmx";
      };

      config = mkOption {
        type = configType;
        default = {};
        description = ''
          Davmail configuration. Refer to
          <http://davmail.sourceforge.net/serversetup.html>
          and <http://davmail.sourceforge.net/advanced.html>
          for details on supported values.
        '';
        example = literalExpression ''
          {
            davmail.allowRemote = true;
            davmail.imapPort = 55555;
            davmail.bindAddress = "10.0.1.2";
            davmail.smtpSaveInSent = true;
            davmail.folderSizeLimit = 10;
            davmail.caldavAutoSchedule = false;
            log4j.logger.rootLogger = "DEBUG";
          }
        '';
      };
    };

    config = mkIf cfg.enable {

      services.davmail.config = {
        davmail = mapAttrs (name: mkDefault) {
          server = true;
          disableUpdateCheck = true;
          logFilePath = "/var/log/davmail/davmail.log";
          logFileSize = "1MB";
          mode = "auto";
          url = cfg.url;
          caldavPort = 1080;
          imapPort = 1143;
          ldapPort = 1389;
          popPort = 1110;
          smtpPort = 1025;
        };
        log4j = {
          logger.davmail = mkDefault "WARN";
          logger.httpclient.wire = mkDefault "WARN";
          logger.org.apache.commons.httpclient = mkDefault "WARN";
          rootLogger = mkDefault "WARN";
        };
      };

      systemd.services.davmail = {
        description = "DavMail POP/IMAP/SMTP Exchange Gateway";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.davmail}/bin/davmail ${configFile}";
          Restart = "on-failure";
          DynamicUser = "yes";
          LogsDirectory = "davmail";

          CapabilityBoundingSet = [ "" ];
          DeviceAllow = [ "" ];
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectSystem = "strict";
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RemoveIPC = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
          SystemCallErrorNumber = "EPERM";
          UMask = "0077";

        };
      };

      environment.systemPackages = [ pkgs.davmail ];
    };
  }
