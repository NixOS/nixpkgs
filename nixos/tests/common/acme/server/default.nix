# The certificate for the ACME service is exported as:
#
#   config.test-support.acme.caCert
#
# This value can be used inside the configuration of other test nodes to inject
# the test certificate into security.pki.certificateFiles or into package
# overlays.
#
# The hosts file of this node will be populated with a mapping of certificate
# domains (including extraDomainNames) to their parent nodes in the test suite.
# This negates the need for a DNS server for most testing. You can still specify
# a custom nameserver/resolver if necessary for other reasons.
{
  config,
  pkgs,
  lib,
  nodes ? { },
  ...
}:
let
  testCerts = import ./snakeoil-certs.nix;
  domain = testCerts.domain;

  pebbleConf.pebble = {
    listenAddress = "0.0.0.0:443";
    managementListenAddress = "0.0.0.0:15000";
    # These certs and keys are used for the Web Front End (WFE)
    certificate = testCerts.${domain}.cert;
    privateKey = testCerts.${domain}.key;
    httpPort = 80;
    tlsPort = 443;
    ocspResponderURL = "http://${domain}:4002";
    strict = true;
  };

  pebbleConfFile = pkgs.writeText "pebble.conf" (builtins.toJSON pebbleConf);

in
{
  options.test-support.acme = {
    caDomain = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = domain;
      description = ''
        A domain name to use with the `nodes` attribute to
        identify the CA server.
      '';
    };
    caCert = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      default = testCerts.ca.cert;
      description = ''
        A certificate file to use with the `nodes` attribute to
        inject the test CA certificate used in the ACME server into
        {option}`security.pki.certificateFiles`.
      '';
    };
  };

  config = {
    networking = {
      firewall.allowedTCPPorts = [
        80
        443
        15000
        4002
      ];

      # Match the caDomain - nixos/lib/testing/network.nix will then add a record for us to
      # all nodes in /etc/hosts
      hostName = "acme";
      domain = "test";

      # Extend /etc/hosts to resolve all configured certificates to their hosts.
      # This way, no DNS server will be needed to validate HTTP-01 certs.
      hosts = lib.attrsets.concatMapAttrs (
        _: node:
        let
          inherit (node.networking) primaryIPAddress primaryIPv6Address;
          ips = builtins.filter (ip: ip != "") [
            primaryIPAddress
            primaryIPv6Address
          ];
          names = lib.lists.unique (
            lib.lists.flatten (
              lib.lists.concatMap
                (
                  cfg:
                  lib.attrsets.mapAttrsToList (
                    domain: cfg:
                    builtins.map (builtins.replaceStrings [ "*." ] [ "" ]) ([ domain ] ++ cfg.extraDomainNames)
                  ) cfg.configuration.security.acme.certs
                )
                # A specialisation's config is nested under its configuration attribute.
                # For ease of use, nest the root node's configuration similarly.
                ([ { configuration = node; } ] ++ (builtins.attrValues node.specialisation))
            )
          );
        in
        builtins.listToAttrs (builtins.map (ip: lib.attrsets.nameValuePair ip names) ips)
      ) nodes;
    };

    systemd.services = {
      pebble = {
        enable = true;
        description = "Pebble ACME server";
        wantedBy = [ "network.target" ];
        environment = {
          # We're not testing lego, we're just testing our configuration.
          # No need to sleep or randomly fail nonces.
          PEBBLE_VA_NOSLEEP = "1";
          PEBBLE_WFE_NONCEREJECT = "0";
        };

        serviceConfig = {
          RuntimeDirectory = "pebble";
          WorkingDirectory = "/run/pebble";

          # Required to bind on privileged ports.
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

          ExecStart = "${pkgs.pebble}/bin/pebble -config ${pebbleConfFile}";
        };
      };
    };
  };
}
