{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  pkg = pkgs.nixops-dns;
  cfg = config.services.nixops-dns;
in

{
  options = {
    services.nixops-dns = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the nixops-dns resolution
          of NixOps virtual machines via dnsmasq and fake domain name.
        '';
      };

      user = mkOption {
        type = types.str;
        description = ''
          The user the nixops-dns daemon should run as.
          This should be the user, which is also used for nixops and
          have the .nixops directory in its home.
        '';
      };

      domain = mkOption {
        type = types.str;
        description = ''
          Fake domain name to resolve to NixOps virtual machines.

          For example "ops" will resolve "vm.ops".
        '';
        default = "ops";
      };

      dnsmasq = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable dnsmasq forwarding to nixops-dns. This allows to use
          nixops-dns for `services.nixops-dns.domain` resolution
          while forwarding the rest of the queries to original resolvers.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.nixops-dns = {
      description = "nixops-dns: DNS server for resolving NixOps machines";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        ExecStart = "${pkg}/bin/nixops-dns --domain=.${cfg.domain}";
      };
    };

    services.dnsmasq = mkIf cfg.dnsmasq {
      enable = true;
      resolveLocalQueries = true;
      servers = [
        "/${cfg.domain}/127.0.0.1#5300"
      ];
      extraConfig = ''
        bind-interfaces
        listen-address=127.0.0.1
      '';
    };

  };
}
