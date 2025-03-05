{ config, lib, pkgs, ... }:
let

  cfg = config.programs.proxychains;

  configFile = ''
    ${cfg.chain.type}_chain
    ${lib.optionalString (cfg.chain.type == "random")
    "chain_len = ${builtins.toString cfg.chain.length}"}
    ${lib.optionalString cfg.proxyDNS "proxy_dns"}
    ${lib.optionalString cfg.quietMode "quiet_mode"}
    remote_dns_subnet ${builtins.toString cfg.remoteDNSSubnet}
    tcp_read_time_out ${builtins.toString cfg.tcpReadTimeOut}
    tcp_connect_time_out ${builtins.toString cfg.tcpConnectTimeOut}
    localnet ${cfg.localnet}
    [ProxyList]
    ${builtins.concatStringsSep "\n"
      (lib.mapAttrsToList (k: v: "${v.type} ${v.host} ${builtins.toString v.port}")
        (lib.filterAttrs (k: v: v.enable) cfg.proxies))}
  '';

  proxyOptions = {
    options = {
      enable = lib.mkEnableOption "this proxy";

      type = lib.mkOption {
        type = lib.types.enum [ "http" "socks4" "socks5" ];
        description = "Proxy type.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        description = "Proxy host or IP address.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        description = "Proxy port";
      };
    };
  };

in {

  ###### interface

  options = {

    programs.proxychains = {

      enable = lib.mkEnableOption "proxychains configuration";

      package = lib.mkPackageOption pkgs "proxychains" {
        example = "proxychains-ng";
      };

      chain = {
        type = lib.mkOption {
          type = lib.types.enum [ "dynamic" "strict" "random" ];
          default = "strict";
          description = ''
            `dynamic` - Each connection will be done via chained proxies
            all proxies chained in the order as they appear in the list
            at least one proxy must be online to play in chain
            (dead proxies are skipped)
            otherwise `EINTR` is returned to the app.

            `strict` - Each connection will be done via chained proxies
            all proxies chained in the order as they appear in the list
            all proxies must be online to play in chain
            otherwise `EINTR` is returned to the app.

            `random` - Each connection will be done via random proxy
            (or proxy chain, see {option}`programs.proxychains.chain.length`) from the list.
          '';
        };
        length = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = ''
            Chain length for random chain.
          '';
        };
      };

      proxyDNS = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Proxy DNS requests - no leak for DNS data.";
      };

      quietMode = lib.mkEnableOption "Quiet mode (no output from the library)";

      remoteDNSSubnet = lib.mkOption {
        type = lib.types.enum [ 10 127 224 ];
        default = 224;
        description = ''
          Set the class A subnet number to use for the internal remote DNS mapping, uses the reserved 224.x.x.x range by default.
        '';
      };

      tcpReadTimeOut = lib.mkOption {
        type = lib.types.int;
        default = 15000;
        description = "Connection read time-out in milliseconds.";
      };

      tcpConnectTimeOut = lib.mkOption {
        type = lib.types.int;
        default = 8000;
        description = "Connection time-out in milliseconds.";
      };

      localnet = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.0/255.0.0.0";
        description = "By default enable localnet for loopback address ranges.";
      };

      proxies = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule proxyOptions);
        description = ''
          Proxies to be used by proxychains.
        '';

        example = lib.literalExpression ''
          { myproxy =
            { type = "socks4";
              host = "127.0.0.1";
              port = 1337;
            };
          }
        '';
      };

    };

  };

  ###### implementation

  meta.maintainers = with lib.maintainers; [ sorki ];

  config = lib.mkIf cfg.enable {

    assertions = lib.singleton {
      assertion = cfg.chain.type != "random" && cfg.chain.length == null;
      message = ''
        Option `programs.proxychains.chain.length`
        only makes sense with `programs.proxychains.chain.type` = "random".
      '';
    };

    programs.proxychains.proxies = lib.mkIf config.services.tor.client.enable
      {
        torproxy = lib.mkDefault {
          enable = true;
          type = "socks4";
          host = "127.0.0.1";
          port = 9050;
        };
      };

    environment.etc."proxychains.conf".text = configFile;
    environment.systemPackages = [ cfg.package ];
  };

}
