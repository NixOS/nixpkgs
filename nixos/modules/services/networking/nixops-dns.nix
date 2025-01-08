{
  config,
  lib,
  pkgs,
  ...
}:

let
  pkg = pkgs.nixops-dns;
  cfg = config.services.nixops-dns;
in

{
  options = {
    services.nixops-dns = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the nixops-dns resolution
          of NixOps virtual machines via dnsmasq and fake domain name.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        description = ''
          The user the nixops-dns daemon should run as.
          This should be the user, which is also used for nixops and
          have the .nixops directory in its home.
        '';
      };

      domain = lib.mkOption {
        type = lib.types.str;
        description = ''
          Fake domain name to resolve to NixOps virtual machines.

          For example "ops" will resolve "vm.ops".
        '';
        default = "ops";
      };

      dnsmasq = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable dnsmasq forwarding to nixops-dns. This allows to use
          nixops-dns for `services.nixops-dns.domain` resolution
          while forwarding the rest of the queries to original resolvers.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nixops-dns = {
      description = "nixops-dns: DNS server for resolving NixOps machines";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        ExecStart = "${pkg}/bin/nixops-dns --domain=.${cfg.domain}";
      };
    };

    services.dnsmasq = lib.mkIf cfg.dnsmasq {
      enable = true;
      resolveLocalQueries = true;
      servers = [
        "/${cfg.domain}/127.0.0.1#5300"
      ];
      settings = {
        bind-interfaces = true;
        listen-address = "127.0.0.1";
      };
    };

  };
}
