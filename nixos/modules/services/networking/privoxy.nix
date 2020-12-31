{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) privoxy;

  cfg = config.services.privoxy;

  confFile = pkgs.writeText "privoxy.conf" (''
    user-manual ${privoxy}/share/doc/privoxy/user-manual
    confdir ${privoxy}/etc/
    listen-address  ${cfg.listenAddress}
    enable-edit-actions ${if (cfg.enableEditActions == true) then "1" else "0"}
    ${concatMapStrings (f: "actionsfile ${f}\n") cfg.actionsFiles}
    ${concatMapStrings (f: "filterfile ${f}\n") cfg.filterFiles}
  '' + optionalString cfg.enableTor ''
    forward-socks4a / ${config.services.tor.client.socksListenAddressFaster} .
    toggle 1
    enable-remote-toggle 0
    enable-edit-actions 0
    enable-remote-http-toggle 0
  '' + ''
    ${cfg.extraConfig}
  '');

in

{

  ###### interface

  options = {

    services.privoxy = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Privoxy non-caching filtering proxy.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1:8118";
        description = ''
          Address the proxy server is listening to.
        '';
      };

      actionsFiles = mkOption {
        type = types.listOf types.str;
        example = [ "match-all.action" "default.action" "/etc/privoxy/user.action" ];
        default = [ "match-all.action" "default.action" ];
        description = ''
          List of paths to Privoxy action files.
          These paths may either be absolute or relative to the privoxy configuration directory.
        '';
      };

      filterFiles = mkOption {
        type = types.listOf types.str;
        example = [ "default.filter" "/etc/privoxy/user.filter" ];
        default = [ "default.filter" ];
        description = ''
          List of paths to Privoxy filter files.
          These paths may either be absolute or relative to the privoxy configuration directory.
        '';
      };

      enableEditActions = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not the web-based actions file editor may be used.
        '';
      };

      enableTor = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to configure Privoxy to use Tor's faster SOCKS port,
          suitable for HTTP.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "" ;
        description = ''
          Extra configuration. Contents will be added verbatim to the configuration file.
        '';
      };
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    users.users.privoxy = {
      isSystemUser = true;
      home = "/var/empty";
      group = "privoxy";
    };

    users.groups.privoxy = {};

    systemd.services.privoxy = {
      description = "Filtering web proxy";
      after = [ "network.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${privoxy}/bin/privoxy --no-daemon --user privoxy ${confFile}";

      serviceConfig.PrivateDevices = true;
      serviceConfig.PrivateTmp = true;
      serviceConfig.ProtectHome = true;
      serviceConfig.ProtectSystem = "full";
    };

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
