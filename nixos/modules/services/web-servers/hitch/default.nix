{ config, lib, pkgs, ...}:
let
  cfg = config.services.hitch;
  hitchConfig = with lib; pkgs.writeText "hitch.conf" (concatStringsSep "\n" [
    ("backend = \"${cfg.backend}\"")
    ("frontend = \"${cfg.frontend}\"")
    (concatMapStrings (s: "pem-file = \"${s}\"\n") cfg.pem-files)
    ("ciphers = \"${cfg.ciphers}\"")
    ("ocsp-dir = \"${cfg.ocspStaplingDir}\"")
    "user = \"${cfg.user}\""
    "group = \"${cfg.group}\""
    cfg.extraConfig
  ]);
in
with lib;
{
  options = {
    services.hitch = {
      enable = mkEnableOption "Hitch Server";

      backend = mkOption {
        type = types.str;
        description = ''
          The host and port Hitch connects to when receiving
          a connection
        '';
      };

      ciphers = mkOption {
        type = types.str;
        default = "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
        description = "The list of ciphers to use";
      };

      frontend = mkOption {
        type = types.either types.str (types.listOf types.str);
        default = "[127.0.0.1]:443";
        description = ''
          This specifies the port and interface (the listen endpoint) that Hitch
          binds to when listening for connections. In the form [HOST]:PORT[+CERT]
        '';
      };

      pem-files = mkOption {
        type = types.listOf types.path;
        default = [];
        description = "PEM files to use";
      };

      ocspStaplingDir = mkOption {
        type = types.path;
        default = "/var/run/hitch/ocsp-cache";
        description = "The location of the OCSP Stapling cache";
      };

      user = mkOption {
        type = types.str;
        default = "hitch";
        description = "The user to run as";
      };

      group = mkOption {
        type = types.str;
        default = "hitch";
        description = "The group to run as";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional configuration lines";
      };
    };

  };

  config = mkIf cfg.enable {

    systemd.services.hitch = {
      description = "Hitch";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        ${pkgs.hitch}/sbin/hitch -t --config ${hitchConfig}
        mkdir -p ${cfg.ocspStaplingDir}
        chown -R hitch:hitch ${cfg.ocspStaplingDir}
      '';
      postStop = ''
        rm -rf ${cfg.ocspStaplingDir}
      '';
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.hitch}/sbin/hitch --daemon --config ${hitchConfig}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "always";
        RestartSec = "5s";
        LimitNOFILE = 131072;
      };
    };

    environment.systemPackages = [ pkgs.hitch ];

    users.extraUsers.hitch = {
      group = "hitch";
    };

    users.extraGroups.hitch = {};
  };
}
