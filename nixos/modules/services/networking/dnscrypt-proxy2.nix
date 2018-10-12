{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.services.dnscrypt-proxy2;

  json = pkgs.writeText "dnscrypt-proxy.json" (builtins.toJSON cfg.config);

  toml = pkgs.runCommand "dnscrypt-proxy.toml" {} ''
    ${pkgs.remarshal}/bin/json2toml < ${json} > $out
  '';
in

{
  options.services.dnscrypt-proxy2 = {
    enable = mkEnableOption "dnscrypt-proxy";

    config = mkOption {
      description = ''
        Attrset that is converted and passed as TOML config file.
        For available params, see: https://git.io/fxBne
      '';
      example = literalExample ''
        {
          sources.public-resolvers = {
            urls = [ "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md" ];
            cache_file = "public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            refresh_delay = 72;
          };
        }
      '';
      type = types.attrs;
    };

    package = mkOption {
      default = pkgs.dnscrypt-proxy2;
      description = ''
        dnscrypt-proxy2 package to use.
      '';
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    networking.nameservers = lib.mkDefault [ "127.0.0.1" ];

    systemd.services.dnscrypt-proxy2 = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/dnscrypt-proxy -config ${toml}";
      };
    };
  };
}
