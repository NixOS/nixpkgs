/*
  A NixOS test module that provides a DNS server and configures it on all nodes.
*/
{ config, lib, ... }:
let

  inherit (lib)
    concatMapStringsSep
    mkOption types
    ;

  cfg = config.dns;

in
{

  options = {
    dns.nodeName = mkOption {
      description = ''
        The `<name>` in `nodes.<name>` for the DNS server.
      '';
      type = types.str;
      default = "dns";
    };
  };

  config = {

    nodes.${cfg.nodeName} = { nodes, pkgs, ... }: {
      networking.firewall.allowedUDPPorts = [ 53 ];
      services.bind.enable = true;
      services.bind.extraOptions = "empty-zones-enable no;";
      services.bind.zones = [{
        name = ".";
        master = true;
        file = pkgs.writeText "root.zone" ''
          $TTL 3600
          . IN SOA ${cfg.nodeName}. ${cfg.nodeName}. ( 1 8 2 4 1 )
          . IN NS ${cfg.nodeName}.
          ${concatMapStringsSep
            "\n"
            (node: "${node.networking.bindZoneRules}")
            (builtins.attrValues nodes)
          }
        '';
      }];
    };

    defaults = { nodes, config, options, ... }: {
      options = {
        networking.bindZoneRules = mkOption {
          type = types.lines;
          description = ''
            This node's contribution to the bind DNS server config that's in the test network.

            NixOS specialisations are ignored.

            The default is defined with regular priority, so that it is merged with normal definitions. Use `lib.mkForce` to replace the default.
          '';
          defaultText = "\"\${if domain == null then hostName else fqdn}. IN A \${config.networking.primaryIPAddress}\"";
        };
      };
      config =
        let
          # TODO apply https://github.com/NixOS/nixpkgs/pull/194759
          fqdn =
            if config.networking.domain == null
            then config.networking.hostName
            else config.networking.fqdn;
        in
        {
          networking.dhcpcd.enable = false;
          environment.etc."resolv.conf".text = ''
            nameserver ${nodes.${cfg.nodeName}.networking.primaryIPAddress}
          '';
          networking.bindZoneRules =
            "${fqdn}. IN A ${config.networking.primaryIPAddress}";
        };
    };

  };

}
