{ config, lib, pkgs, ... }:

let
  cfg = config.services.shibboleth-sp;
in {
  options = {
    services.shibboleth-sp = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable the shibboleth service";
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        example = lib.literalExpression ''"''${pkgs.shibboleth-sp}/etc/shibboleth/shibboleth2.xml"'';
        description = lib.mdDoc "Path to shibboleth config file";
      };

      fastcgi.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc "Whether to include the shibauthorizer and shibresponder FastCGI processes";
      };

      fastcgi.shibAuthorizerPort = lib.mkOption {
        type = lib.types.int;
        default = 9100;
        description = lib.mdDoc "Port for shibauthorizer FastCGI process to bind to";
      };

      fastcgi.shibResponderPort = lib.mkOption {
        type = lib.types.int;
        default = 9101;
        description = lib.mdDoc "Port for shibauthorizer FastCGI process to bind to";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.shibboleth-sp = {
      description = "Provides SSO and federation for web applications";
      after       = lib.optionals cfg.fastcgi.enable [ "shibresponder.service" "shibauthorizer.service" ];
      wantedBy    = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.shibboleth-sp}/bin/shibd -F -d ${pkgs.shibboleth-sp} -c ${cfg.configFile}";
      };
    };

    systemd.services.shibresponder = lib.mkIf cfg.fastcgi.enable {
      description = "Provides SSO through Shibboleth via FastCGI";
      after       = [ "network.target" ];
      wantedBy    = [ "multi-user.target" ];
      path    	  = [ "${pkgs.spawn_fcgi}" ];
      environment.SHIBSP_CONFIG = "${cfg.configFile}";
      serviceConfig = {
        ExecStart = "${pkgs.spawn_fcgi}/bin/spawn-fcgi -n -p ${toString cfg.fastcgi.shibResponderPort} ${pkgs.shibboleth-sp}/lib/shibboleth/shibresponder";
      };
    };

    systemd.services.shibauthorizer = lib.mkIf cfg.fastcgi.enable {
      description = "Provides SSO through Shibboleth via FastCGI";
      after       = [ "network.target" ];
      wantedBy    = [ "multi-user.target" ];
      path    	  = [ "${pkgs.spawn_fcgi}" ];
      environment.SHIBSP_CONFIG = "${cfg.configFile}";
      serviceConfig = {
        ExecStart = "${pkgs.spawn_fcgi}/bin/spawn-fcgi -n -p ${toString cfg.fastcgi.shibAuthorizerPort} ${pkgs.shibboleth-sp}/lib/shibboleth/shibauthorizer";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ ];
}
