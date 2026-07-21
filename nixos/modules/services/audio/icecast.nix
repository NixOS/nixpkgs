{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkRemovedOptionModule
    mkRenamedOptionModule
    ;

  cfg = config.services.icecast;
  configFile = pkgs.writeText "icecast.xml" ''
    <?xml version="1.0"?>
    <icecast>
      <hostname>${cfg.hostname}</hostname>

      <authentication>
        <admin-user>${cfg.admin.user}</admin-user>
        <admin-password>${cfg.admin.password}</admin-password>
      </authentication>

      <paths>
        <logdir>/var/log/icecast</logdir>
        <adminroot>${pkgs.icecast}/share/icecast/admin</adminroot>
        <webroot>${pkgs.icecast}/share/icecast/web</webroot>
        <alias source="/" dest="/status.xsl"/>
      </paths>

      <listen-socket>
        <port>${toString cfg.listen.port}</port>
        <bind-address>${cfg.listen.address}</bind-address>
      </listen-socket>

      <security>
        <chroot>0</chroot>
      </security>

      ${cfg.extraConfig}
    </icecast>
  '';
in
{

  imports = [
    (mkRemovedOptionModule [ "services" "icecast" "logDir" ] ''
      The log directory is now managed by systemd's LogsDirectory= directive.
    '')
    (mkRemovedOptionModule [ "services" "icecast" "user" ] ''
      The service now runs under the dynamically allocated `icecast` user.
    '')
    (mkRemovedOptionModule [ "services" "icecast" "group" ] ''
      The service now runs under the dynamically allocated `icecast` group.
    '')
    (mkRenamedOptionModule [ "services" "icecast" "extraConf" ] [ "services" "icecast" "extraConfig" ])
  ];

  ###### interface

  options = {

    services.icecast = {

      enable = lib.mkEnableOption "Icecast server";

      hostname = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "DNS name or IP address that will be used for the stream directory lookups or possibly the playlist generation if a Host header is not provided.";
        default = config.networking.domain;
        defaultText = lib.literalExpression "config.networking.domain";
      };

      admin = {
        user = lib.mkOption {
          type = lib.types.str;
          description = "Username used for all administration functions.";
          default = "admin";
        };

        password = lib.mkOption {
          type = lib.types.str;
          description = "Password used for all administration functions.";
        };
      };

      listen = {
        port = lib.mkOption {
          type = lib.types.port;
          description = "TCP port that will be used to accept client connections.";
          default = 8000;
        };

        address = lib.mkOption {
          type = lib.types.str;
          description = "Address Icecast will listen on.";
          default = "::";
        };
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration added to {file}`icecast.xml` inside the `<icecast>` element.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.services.icecast = {
      after = [ "network.target" ];
      description = "Icecast Network Audio Streaming Server";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        ExecStart = toString [
          (lib.getExe pkgs.icecast)
          "-c"
          configFile
        ];
        ExecReload = toString [
          (lib.getExe' pkgs.coreutils "kill")
          "-HUP"
          "$MAINPID"
        ];
        LogsDirectory = "icecast";
      };
    };

  };

}
