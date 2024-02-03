{ config, lib, pkgs, ... }:
with lib;
let

  cfg = config.programs.proxychains;

  configFile = ''
    ${cfg.chain.type}_chain
    ${optionalString (cfg.chain.type == "random")
    "chain_len = ${builtins.toString cfg.chain.length}"}
    ${optionalString cfg.proxyDNS "proxy_dns"}
    ${optionalString cfg.quietMode "quiet_mode"}
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
      enable = mkEnableOption (lib.mdDoc "this proxy");

      type = mkOption {
        type = types.enum [ "http" "socks4" "socks5" ];
        description = lib.mdDoc "Proxy type.";
      };

      host = mkOption {
        type = types.str;
        description = lib.mdDoc "Proxy host or IP address.";
      };

      port = mkOption {
        type = types.port;
        description = lib.mdDoc "Proxy port";
      };
    };
  };

in {

  ###### interface

  options = {

    programs.proxychains = {

      enable = mkEnableOption (lib.mdDoc "installing proxychains configuration");

      package = mkPackageOptionMD pkgs "proxychains" {
        example = "pkgs.proxychains-ng";
      };

      chain = {
        type = mkOption {
          type = types.enum [ "dynamic" "strict" "random" ];
          default = "strict";
          description = lib.mdDoc ''
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
        length = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Chain length for random chain.
          '';
        };
      };

      proxyDNS = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Proxy DNS requests - no leak for DNS data.";
      };

      quietMode = mkEnableOption (lib.mdDoc "Quiet mode (no output from the library)");

      remoteDNSSubnet = mkOption {
        type = types.enum [ 10 127 224 ];
        default = 224;
        description = lib.mdDoc ''
          Set the class A subnet number to use for the internal remote DNS mapping, uses the reserved 224.x.x.x range by default.
        '';
      };

      tcpReadTimeOut = mkOption {
        type = types.int;
        default = 15000;
        description = lib.mdDoc "Connection read time-out in milliseconds.";
      };

      tcpConnectTimeOut = mkOption {
        type = types.int;
        default = 8000;
        description = lib.mdDoc "Connection time-out in milliseconds.";
      };

      localnet = mkOption {
        type = types.str;
        default = "127.0.0.0/255.0.0.0";
        description = lib.mdDoc "By default enable localnet for loopback address ranges.";
      };

      proxies = mkOption {
        type = types.attrsOf (types.submodule proxyOptions);
        description = lib.mdDoc ''
          Proxies to be used by proxychains.
        '';

        example = literalExpression ''
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

  meta.maintainers = with maintainers; [ sorki ];

  config = mkIf cfg.enable {

    assertions = singleton {
      assertion = cfg.chain.type != "random" && cfg.chain.length == null;
      message = ''
        Option `programs.proxychains.chain.length`
        only makes sense with `programs.proxychains.chain.type` = "random".
      '';
    };

    programs.proxychains.proxies = mkIf config.services.tor.client.enable
      {
        torproxy = mkDefault {
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
