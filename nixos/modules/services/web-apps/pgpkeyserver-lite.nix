{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.pgpkeyserver-lite;
  sksCfg = config.services.sks;

  webPkg = cfg.package;

in

{

  options = {

    services.pgpkeyserver-lite = {

      enable = mkEnableOption "pgpkeyserver-lite on a nginx vHost proxying to a gpg keyserver";

      package = mkOption {
        default = pkgs.pgpkeyserver-lite;
        defaultText = "pkgs.pgpkeyserver-lite";
        type = types.package;
        description = "
          Which webgui derivation to use.
        ";
      };

      hostname = mkOption {
        type = types.str;
        description = "
          Which hostname to set the vHost to that is proxying to sks.
        ";
      };     

      hkpAddress = mkOption {
        default = sksCfg.hkpAddress;
        type = types.listOf types.str;
        description = "
          Wich ip address the sks-keyserver is listening on.
        ";
      };

      hkpPort = mkOption {
        default = sksCfg.hkpPort;
        type = types.int;
        description = "
          Which port the sks-keyserver is listening on.
        ";
      };
    };
  };

  config = mkIf cfg.enable {

    services.nginx.enable = true;

    services.nginx.virtualHosts = let
      hkpAddress = builtins.concatStringsSep " " cfg.hkpAddress;
      hkpPort = builtins.toString cfg.hkpPort;
    in {
      "${cfg.hostname}" = {
        root = webPkg;
        locations = {
          "/pks".extraConfig = ''
            proxy_pass         http://${hkpAddress}:${hkpPort};
            proxy_pass_header  Server;
            add_header         Via "1.1 ${cfg.hostname}";
          '';
        };
      };
    };
  };
}
