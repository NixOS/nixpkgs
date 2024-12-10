# The certificate for the ACME service is exported as:
#
#   config.test-support.acme.caCert
#
# This value can be used inside the configuration of other test nodes to inject
# the test certificate into security.pki.certificateFiles or into package
# overlays.
#
# Another value that's needed if you don't use a custom resolver (see below for
# notes on that) is to add the acme node as a nameserver to every node
# that needs to acquire certificates using ACME, because otherwise the API host
# for acme.test can't be resolved.
#
# A configuration example of a full node setup using this would be this:
#
# {
#   acme = import ./common/acme/server;
#
#   example = { nodes, ... }: {
#     networking.nameservers = [
#       nodes.acme.networking.primaryIPAddress
#     ];
#     security.pki.certificateFiles = [
#       nodes.acme.test-support.acme.caCert
#     ];
#   };
# }
#
# By default, this module runs a local resolver, generated using resolver.nix
# from the parent directory to automatically discover all zones in the network.
#
# If you do not want this and want to use your own resolver, you can just
# override networking.nameservers like this:
#
# {
#   acme = { nodes, lib, ... }: {
#     imports = [ ./common/acme/server ];
#     networking.nameservers = lib.mkForce [
#       nodes.myresolver.networking.primaryIPAddress
#     ];
#   };
#
#   myresolver = ...;
# }
#
# Keep in mind, that currently only _one_ resolver is supported, if you have
# more than one resolver in networking.nameservers only the first one will be
# used.
#
# Also make sure that whenever you use a resolver from a different test node
# that it has to be started _before_ the ACME service.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  testCerts = import ./snakeoil-certs.nix;
  domain = testCerts.domain;

  resolver =
    let
      message = "You need to define a resolver for the acme test module.";
      firstNS = lib.head config.networking.nameservers;
    in
    if config.networking.nameservers == [ ] then throw message else firstNS;

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
  imports = [ ../../resolver.nix ];

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
    test-support = {
      resolver.enable =
        let
          isLocalResolver = config.networking.nameservers == [ "127.0.0.1" ];
        in
        lib.mkOverride 900 isLocalResolver;
    };

    # This has priority 140, because modules/testing/test-instrumentation.nix
    # already overrides this with priority 150.
    networking.nameservers = lib.mkOverride 140 [ "127.0.0.1" ];
    networking.firewall.allowedTCPPorts = [
      80
      443
      15000
      4002
    ];

    networking.extraHosts = ''
      127.0.0.1 ${domain}
      ${config.networking.primaryIPAddress} ${domain}
    '';

    systemd.services = {
      pebble = {
        enable = true;
        description = "Pebble ACME server";
        wantedBy = [ "network.target" ];
        environment = {
          # We're not testing lego, we're just testing our configuration.
          # No need to sleep.
          PEBBLE_VA_NOSLEEP = "1";
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
