{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    optionals
    types
    ;

  cfg = config.services.quakejs;
  format = pkgs.formats.json { };

in
{
  options.services.quakejs = {

    enable = mkEnableOption "Game server for QuakeJS";

    package = mkPackageOption pkgs "QuakeJS" { };

    hostname = mkOption {
      default = "localhost";
      type = types.uniq types.str;
      example = ''example.com'';
      description = ''
        The hostname on which to listen.
      '';
    };

    eula = mkOption {
      type = types.bool;
      description = ''
        By changing this option to true you confirm that you own a copy of Quake 3 Arena,
        and that you agree to the EULA.
      '';
      default = false;
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open firewall for web client, dedicated and content server.
      '';
    };

    settings = mkOption {
      type = types.submodule { freeformType = format.type; };
      description = ''
        Configuration for the web game client.
      '';
      default = {
        content = "content.quakejs.com";
        port = 8080;
      };
      example = literalExpression ''
        {
          content = "content.quakejs.com";
          port = 8081;
        }
      '';
    };

    content-server = {

      enable = mkEnableOption "Content server for QuakeJS";

      hostname = mkOption {
        default = "localhost";
        type = types.uniq types.str;
        example = ''example.com'';
        description = ''
          Hostname to use. It should be FQDN.
        '';
      };

      settings = mkOption {
        type = types.submodule { freeformType = format.type; };
        description = ''
          Configuration for the content server.
        '';
        default = {
          root = "/var/lib/quakejs";
          port = 8081;
        };
      };

    };

    dedicated-server = {

      enable = mkEnableOption "Dedicated server for QuakeJS";

      port = mkOption {
        type = types.port;
        default = 27960;
        description = ''
          Port for the server to listen on.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        description = ''
          Extra configuration options. Note that options changed via RCON will not be persisted. To list all possible options, use ``cvarlist 1`` via RCON.
        '';
        default = ''
          set dedicated 2
          seta sv_hostname "QuakeJS NixOS Server"
          seta timelimit 30
          seta fraglimit 30
          seta g_inactivity 3000
          seta g_forcerespawn 0
          set d1 "map q3dm7 ; set nextmap vstr d2"
          set d2 "map q3dm17 ; set nextmap vstr d1"
          vstr "d1"
        '';
        example = literalExpression ''
          seta g_motd "Happy fragging!";
          seta g_gametype 0
          set fs_game "baseq3"
          set fs_cdn "content.quakejs.com"
        '';
      };

    };

  };

  config = {

    systemd.services.quakejs-ds = mkIf (cfg.dedicated-server.enable) {
      description = "Dedicated server for QuakeJS";
      environment = mkIf cfg.eula { QUAKEJS_ACCEPT_EULA = "true"; };
      serviceConfig = {
        ExecStart = "${pkgs.quakejs}/bin/quakejs-ded +set net_port ${toString cfg.dedicated-server.port} +exec server.cfg";
        WorkingDirectory = "/var/lib/quakejs";
        StateDirectory = [ "quakejs" ];
        Type = "simple";
        DynamicUser = true;
      };
      preStart = ''
        mkdir -p /var/lib/quakejs/base/baseq3
        cp ${pkgs.writeText "server.cfg" cfg.dedicated-server.extraConfig} /var/lib/quakejs/base/baseq3/server.cfg
      '';
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };

    systemd.services.quakejs = mkIf (cfg.enable) {
      description = "Game client for QuakeJS";
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.quakejs} --config ${format.generate "web.json" cfg.settings}";
        WorkingDirectory = "/var/lib/quakejs";
        StateDirectory = [ "quakejs" ];
        Type = "simple";
        DynamicUser = true;
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };

    systemd.services.quakejs-cs = mkIf (cfg.content-server.enable) {
      description = "Content server for QuakeJS";
      serviceConfig = {
        ExecStart = "${pkgs.quakejs}/bin/quakejs-content  --config ${format.generate "config.json" cfg.content-server.settings}";
        WorkingDirectory = "/var/lib/quakejs";
        StateDirectory = [ "quakejs" ];
        Type = "simple";
        DynamicUser = true;
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts =
        optionals (cfg.enable) [ cfg.settings.port ]
        ++ optionals (cfg.content-server.enable) [ cfg.content-server.settings.port ]
        ++ optionals (cfg.dedicated-server.enable) [ cfg.dedicated-server.port ];
    };

    # Secure connections are not yet implemented in QuakeJS.
    # See: https://github.com/inolen/quakejs/pull/72
    services.caddy = mkIf (cfg.enable || cfg.content-server.enable) {
      enable = true;
      virtualHosts =
        (lib.optionalAttrs cfg.enable {
          "http://${cfg.hostname}".extraConfig = ''
            reverse_proxy http://localhost:${toString cfg.settings.port}
          '';
        })
        // (lib.optionalAttrs cfg.content-server.enable {
          "http://${cfg.content-server.hostname}".extraConfig = ''
            reverse_proxy http://localhost:${toString cfg.content-server.settings.port}
          '';
        });
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
