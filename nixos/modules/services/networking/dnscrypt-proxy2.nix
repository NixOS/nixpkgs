{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.services.dnscrypt-proxy2;
in

{
  options.services.dnscrypt-proxy2 = {
    enable = mkEnableOption "dnscrypt-proxy2";

    settings = mkOption {
      description = ''
        Attrset that is converted and passed as TOML config file.
        For available params, see: <link xlink:href="https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml"/>
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
        Path to TOML config file. See: <link xlink:href="https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml"/>
        If this option is set, it will override any configuration done in options.services.dnscrypt-proxy2.settings.
      '';
      example = "/etc/dnscrypt-proxy/dnscrypt-proxy.toml";
      type = types.path;
      default = pkgs.runCommand "dnscrypt-proxy.toml" {
        json = builtins.toJSON cfg.settings;
        passAsFile = [ "json" ];
      } ''
        ${pkgs.remarshal}/bin/json2toml < $jsonPath > $out
      '';
      defaultText = literalExample "TOML file generated from services.dnscrypt-proxy2.settings";
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
        ExecStart = "${pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy -config ${cfg.configFile}";
      };
    };
  };
}
