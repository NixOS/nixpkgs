{ config, lib, options, pkgs, ... }:

with lib;

let

  cfg = config.services.pgpkeyserver-lite;
  sksCfg = config.services.sks;
  sksOpt = options.services.sks;

  webPkg = cfg.package;

in

{

  options = {

    services.pgpkeyserver-lite = {

      enable = mkEnableOption (lib.mdDoc "pgpkeyserver-lite on a nginx vHost proxying to a gpg keyserver");

      package = mkOption {
        default = pkgs.pgpkeyserver-lite;
        defaultText = literalExpression "pkgs.pgpkeyserver-lite";
        type = types.package;
        description = lib.mdDoc ''
          Which webgui derivation to use.
        '';
      };

      hostname = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Which hostname to set the vHost to that is proxying to sks.
        '';
      };

      hkpAddress = mkOption {
        default = builtins.head sksCfg.hkpAddress;
        defaultText = literalExpression "head config.${sksOpt.hkpAddress}";
        type = types.str;
        description = lib.mdDoc ''
          Wich ip address the sks-keyserver is listening on.
        '';
      };

      hkpPort = mkOption {
        default = sksCfg.hkpPort;
        defaultText = literalExpression "config.${sksOpt.hkpPort}";
        type = types.int;
        description = lib.mdDoc ''
          Which port the sks-keyserver is listening on.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.nginx.enable = true;

    services.nginx.virtualHosts = let
      hkpPort = builtins.toString cfg.hkpPort;
    in {
      ${cfg.hostname} = {
        root = webPkg;
        locations = {
          "/pks".extraConfig = ''
            proxy_pass         http://${cfg.hkpAddress}:${hkpPort};
            proxy_pass_header  Server;
            add_header         Via "1.1 ${cfg.hostname}";
          '';
        };
      };
    };
  };
}
