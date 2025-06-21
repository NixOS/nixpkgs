{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.udp-over-tcp;

in
{
  options.networking.udp-over-tcp = {
    tcp2udp = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      example = lib.literalExpression ''
        {
          "0.0.0.0:443" = "127.0.0.1:51820";
        };
      '';
      description = ''
        Mapping of TCP listening ports to UDP forwarding ports.
      '';
      default = { };
    };
    udp2tcp = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      example = lib.literalExpression ''
        {
          "0.0.0.0:51820" = "10.0.0.1:443";
        };
      '';
      description = ''
        Mapping of UDP listening ports to TCP forwarding ports.
      '';
      default = { };
    };
  };

  config = {
    systemd.services =
      (lib.attrsets.mapAttrs' (listen: forward: {
        name = "tcp2udp-${listen}";
        value = {
          description = "tcp2udp tunnel from ${listen} to ${forward}";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          reloadIfChanged = true;
          serviceConfig = {
            Type = "exec";
            ExecStart = "${pkgs.udp-over-tcp}/bin/tcp2udp --tcp-listen ${listen} --udp-forward ${forward}";
          };
        };
      }) cfg.tcp2udp)
      // (lib.attrsets.mapAttrs' (listen: forward: {
        name = "udp2tcp-${listen}";
        value = {
          description = "udp2tcp tunnel from ${listen} to ${forward}";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          reloadIfChanged = true;
          serviceConfig = {
            Type = "exec";
            ExecStart = "${pkgs.udp-over-tcp}/bin/udp2tcp --udp-listen ${listen} --tcp-forward ${forward}";
          };
        };
      }) cfg.udp2tcp);
  };

  meta.maintainers = with lib.maintainers; [ timschumi ];
}
