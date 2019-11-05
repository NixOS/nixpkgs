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
    enable = mkEnableOption "dnscrypt-proxy2";

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
      default = {};
    };

    configFile = mkOption {
      description = ''
        Path to TOML config file. See: https://git.io/fxBne
      '';
      example = literalExample "/etc/dnscrypt-proxy/dnscrypt-proxy.toml";
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = (
        (cfg.config == {} -> cfg.configFile != null) &&
        (cfg.configFile != null -> cfg.config == {})
      );
      message  = ''
        Please specify either
        'services.dnscrypt-proxy2.config' or
        'services.dnscrypt-proxy2.configFile'.
      '';
    }];

    networking.nameservers = lib.mkDefault [ "127.0.0.1" ];

    systemd.services.dnscrypt-proxy2 = let
      configuration = if cfg.configFile == null
                      then toml
                      else cfg.configFile;
    in
    {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        DynamicUser = true;
        ExecStart = "${pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy -config ${configuration}";
      };
    };
  };
}
