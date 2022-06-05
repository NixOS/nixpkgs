{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.services.prosody-filer;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "prosody-filer.toml" cfg.settings;
in {

  options = {
    services.prosody-filer = {
      enable = mkEnableOption "Prosody Filer XMPP upload file server";

      settings = mkOption {
        description = ''
          Configuration for Prosody Filer.
          Refer to <link xlink:href="https://github.com/ThomasLeister/prosody-filer#configure-prosody-filer"/> for details on supported values.
        '';

        type = settingsFormat.type;

        example = {
          secret = "mysecret";
          storeDir = "/srv/http/nginx/prosody-upload";
        };

        defaultText = literalExpression ''
          {
            listenport = mkDefault "127.0.0.1:5050";
            uploadSubDir = mkDefault "upload/";
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.prosody-filer.settings = {
      listenport = mkDefault "127.0.0.1:5050";
      uploadSubDir = mkDefault "upload/";
    };

    users.users.prosody-filer = {
      group = "prosody-filer";
      isSystemUser = true;
    };

    users.groups.prosody-filer = { };

    systemd.services.prosody-filer = {
      description = "Prosody file upload server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = "prosody-filer";
        Group = "prosody-filer";
        ExecStart = "${pkgs.prosody-filer}/bin/prosody-filer -config ${configFile}";
        Restart = "on-failure";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateMounts = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
      };
    };
  };
}
