{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.gobgpd;
  format = pkgs.formats.toml { };
  confFile = format.generate "gobgpd.conf" cfg.settings;
in
{
  options.services.gobgpd = {
    enable = lib.mkEnableOption "GoBGP Routing Daemon";

    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = ''
        GoBGP configuration. Refer to
        <https://github.com/osrg/gobgp#documentation>
        for details on supported values.
      '';
      example = lib.literalExpression ''
        {
          global = {
            config = {
              as = 64512;
              router-id = "192.168.255.1";
            };
          };
          neighbors = [
            {
              config = {
                neighbor-address = "10.0.255.1";
                peer-as = 65001;
              };
            }
            {
              config = {
                neighbor-address = "10.0.255.2";
                peer-as = 65002;
              };
            }
          ];
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gobgpd ];
    systemd.services.gobgpd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "GoBGP Routing Daemon";
      serviceConfig = {
        Type = "notify";
        ExecStartPre = "${pkgs.gobgpd}/bin/gobgpd -f ${confFile} -d";
        ExecStart = "${pkgs.gobgpd}/bin/gobgpd -f ${confFile} --sdnotify";
        ExecReload = "${pkgs.gobgpd}/bin/gobgpd -r";
        DynamicUser = true;
        AmbientCapabilities = "cap_net_bind_service";
      };
    };
  };
}
