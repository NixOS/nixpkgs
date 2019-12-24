# The certificate for the ACME service is exported as:
#
#   config.test-support.letsencrypt.caCert
#
# This value can be used inside the configuration of other test nodes to inject
# the snakeoil certificate into security.pki.certificateFiles or into package
# overlays.
#
# Another value that's needed if you don't use a custom resolver (see below for
# notes on that) is to add the letsencrypt node as a nameserver to every node
# that needs to acquire certificates using ACME, because otherwise the API host
# for letsencrypt.org can't be resolved.
#
# A configuration example of a full node setup using this would be this:
#
# {
#   letsencrypt = import ./common/letsencrypt;
#
#   example = { nodes, ... }: {
#     networking.nameservers = [
#       nodes.letsencrypt.config.networking.primaryIPAddress
#     ];
#     security.pki.certificateFiles = [
#       nodes.letsencrypt.config.test-support.letsencrypt.caCert
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
#   letsencrypt = { nodes, ... }: {
#     imports = [ ./common/letsencrypt ];
#     networking.nameservers = [
#       nodes.myresolver.config.networking.primaryIPAddress
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
{ config, pkgs, lib, ... }:


let
  snakeOilCerts = import ./snakeoil-certs.nix;

  wfeDomain = "acme-v02.api.letsencrypt.org";
  wfeCertFile = snakeOilCerts.${wfeDomain}.cert;
  wfeKeyFile = snakeOilCerts.${wfeDomain}.key;

  siteDomain = "letsencrypt.org";
  siteCertFile = snakeOilCerts.${siteDomain}.cert;
  siteKeyFile = snakeOilCerts.${siteDomain}.key;
  pebble = pkgs.pebble.overrideAttrs (attrs: {
    # The pebble directory endpoint is /dir when the bouder (official
    # ACME server) is /directory. Sadly, this endpoint is hardcoded,
    # we have to patch it.
    #
    # Tried to upstream, that said upstream maintainers rather keep
    # this custom endpoint to test ACME clients robustness. See
    # https://github.com/letsencrypt/pebble/issues/283#issuecomment-545123242
    patches = [ ./0001-Change-ACME-directory-endpoint-to-directory.patch ];
  });

  resolver = let
    message = "You need to define a resolver for the letsencrypt test module.";
    firstNS = lib.head config.networking.nameservers;
  in if config.networking.nameservers == [] then throw message else firstNS;

  pebbleConf.pebble = {
    listenAddress = "0.0.0.0:443";
    managementListenAddress = "0.0.0.0:15000";
    certificate = snakeOilCerts.${wfeDomain}.cert;
    privateKey = snakeOilCerts.${wfeDomain}.key;
    httpPort = 80;
    tlsPort = 443;
    ocspResponderURL = "http://0.0.0.0:4002";
  };

  pebbleConfFile = pkgs.writeText "pebble.conf" (builtins.toJSON pebbleConf);
  pebbleDataDir = "/root/pebble";

in {
  imports = [ ../resolver.nix ];

  options.test-support.letsencrypt.caCert = lib.mkOption {
    type = lib.types.path;
    description = ''
      A certificate file to use with the <literal>nodes</literal> attribute to
      inject the snakeoil CA certificate used in the ACME server into
      <option>security.pki.certificateFiles</option>.
    '';
  };

  config = {
    test-support = {
      resolver.enable = let
        isLocalResolver = config.networking.nameservers == [ "127.0.0.1" ];
      in lib.mkOverride 900 isLocalResolver;
      letsencrypt.caCert = snakeOilCerts.ca.cert;
    };

    # This has priority 140, because modules/testing/test-instrumentation.nix
    # already overrides this with priority 150.
    networking.nameservers = lib.mkOverride 140 [ "127.0.0.1" ];
    networking.firewall.enable = false;

    networking.extraHosts = ''
      127.0.0.1 ${wfeDomain}
      ${config.networking.primaryIPAddress} ${wfeDomain} ${siteDomain}
    '';

    systemd.services = {
      pebble = {
        enable = true;
        description = "Pebble ACME server";
        requires = [ ];
        wantedBy = [ "network.target" ];
        preStart = ''
          mkdir ${pebbleDataDir}
        '';
        script = ''
          cd ${pebbleDataDir}
          ${pebble}/bin/pebble -config ${pebbleConfFile}
        '';
        serviceConfig = {
          # Required to bind on privileged ports.
          User = "root";
          Group = "root";
        };
      };
    };
  };
}
