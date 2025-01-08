{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let

  cfg = config.services.pgpkeyserver-lite;
  sksCfg = config.services.sks;
  sksOpt = options.services.sks;

  webPkg = cfg.package;

in

{

  options = {

    services.pgpkeyserver-lite = {

      enable = lib.mkEnableOption "pgpkeyserver-lite on a nginx vHost proxying to a gpg keyserver";

      package = lib.mkPackageOption pkgs "pgpkeyserver-lite" { };

      hostname = lib.mkOption {
        type = lib.types.str;
        description = ''
          Which hostname to set the vHost to that is proxying to sks.
        '';
      };

      hkpAddress = lib.mkOption {
        default = builtins.head sksCfg.hkpAddress;
        defaultText = lib.literalExpression "head config.${sksOpt.hkpAddress}";
        type = lib.types.str;
        description = ''
          Which IP address the sks-keyserver is listening on.
        '';
      };

      hkpPort = lib.mkOption {
        default = sksCfg.hkpPort;
        defaultText = lib.literalExpression "config.${sksOpt.hkpPort}";
        type = lib.types.int;
        description = ''
          Which port the sks-keyserver is listening on.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services.nginx.enable = true;

    services.nginx.virtualHosts =
      let
        hkpPort = builtins.toString cfg.hkpPort;
      in
      {
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
