{ config, lib, pkgs, ... }:

let
  inherit (lib)
    concatStringsSep
    mkEnableOption mkIf mkOption types;

  cfg = config.services.https-dns-proxy;

  providers = {
    cloudflare = {
      ips = [ "1.1.1.1" "1.0.0.1" ];
      url = "https://cloudflare-dns.com/dns-query";
    };
    google = {
      ips = [ "8.8.8.8" "8.8.4.4" ];
      url = "https://dns.google/dns-query";
    };
    quad9 = {
      ips = [ "9.9.9.9" "149.112.112.112" ];
      url = "https://dns.quad9.net/dns-query";
    };
  };

  defaultProvider = "quad9";

  providerCfg =
    let
      isCustom = cfg.provider.kind == "custom";
    in
    lib.concatStringsSep " " [
      "-b"
      (concatStringsSep "," (if isCustom then cfg.provider.ips else providers."${cfg.provider.kind}".ips))
      "-r"
      (if isCustom then cfg.provider.url else providers."${cfg.provider.kind}".url)
    ];

in
{
  meta.maintainers = with lib.maintainers; [ peterhoeg ];

  ###### interface

  options.services.https-dns-proxy = {
    enable = mkEnableOption "https-dns-proxy daemon";

    address = mkOption {
      description = lib.mdDoc "The address on which to listen";
      type = types.str;
      default = "127.0.0.1";
    };

    port = mkOption {
      description = lib.mdDoc "The port on which to listen";
      type = types.port;
      default = 5053;
    };

    provider = {
      kind = mkOption {
        description = lib.mdDoc ''
          The upstream provider to use or custom in case you do not trust any of
          the predefined providers or just want to use your own.

          The default is ${defaultProvider} and there are privacy and security trade-offs
          when using any upstream provider. Please consider that before using any
          of them.

          If you pick a custom provider, you will need to provide the bootstrap
          IP addresses as well as the resolver https URL.
        '';
        type = types.enum ((builtins.attrNames providers) ++ [ "custom" ]);
        default = defaultProvider;
      };

      ips = mkOption {
        description = lib.mdDoc "The custom provider IPs";
        type = types.listOf types.str;
      };

      url = mkOption {
        description = lib.mdDoc "The custom provider URL";
        type = types.str;
      };
    };

    preferIPv4 = mkOption {
      description = lib.mdDoc ''
        https_dns_proxy will by default use IPv6 and fail if it is not available.
        To play it safe, we choose IPv4.
      '';
      type = types.bool;
      default = true;
    };

    extraArgs = mkOption {
      description = lib.mdDoc "Additional arguments to pass to the process.";
      type = types.listOf types.str;
      default = [ "-v" ];
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    systemd.services.https-dns-proxy = {
      description = "DNS to DNS over HTTPS (DoH) proxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = rec {
        Type = "exec";
        DynamicUser = true;
        ExecStart = lib.concatStringsSep " " (
          [
            "${pkgs.https-dns-proxy}/bin/https_dns_proxy"
            "-a ${toString cfg.address}"
            "-p ${toString cfg.port}"
            "-l -"
            providerCfg
          ]
          ++ lib.optional cfg.preferIPv4 "-4"
          ++ cfg.extraArgs
        );
        Restart = "on-failure";
      };
    };
  };
}
