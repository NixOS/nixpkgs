/*
  This tests ./bind-dns.nix, so it is a test for test-support code.

  Bind itself is tested in ../bind.nix.
*/
{ lib, ... }: {
  name = "testsupport-bind-dns-test";
  meta.maintainers = with lib.maintainers; [ roberth ];

  imports = [ ./bind-dns.nix ];

  defaults = { pkgs, ... }: {
    environment.systemPackages = [ ];
    virtualisation.memorySize = 256; # no demanding programs, so this can be low

    # Make sure we don't accidentally test the hosts file
    networking.hostFiles = lib.mkForce [
      (pkgs.writeText "dead-simple-etc-hosts" ''
        127.0.0.1 localhost
      '')
    ];
  };

  nodes.simple = { };
  nodes.hostname = {
    networking.hostName = "custom-hostname";
    system.name = "hostname";
  };
  nodes.overridedns = { config, ... }: {
    networking.bindZoneRules = lib.mkForce ''
      overriddendns. IN A ${config.networking.primaryIPAddress}
    '';
  };
  nodes.extradns = { config, ... }: {
    networking.bindZoneRules = ''
      an-extra-name. IN A ${config.networking.primaryIPAddress}
    '';
  };
  nodes.indomain = {
    networking.domain = "thedomain";
  };

  testScript = { nodes, ... }: ''
    start_all()

    dns.wait_for_unit("network-online.target")
    dns.wait_for_unit("bind.service")
    dns.wait_for_open_port(53)
    simple.wait_for_unit("network-online.target")

    # Make sure that a helpful test framework + helpful host command can not
    # ruin the test, and our override works (dead-simple-etc-hosts).
    simple.succeed("""
      ! grep custom-hostname /etc/hosts
      """)

    # record is present on server
    simple.succeed("""
      host simple ${nodes.dns.networking.primaryIPAddress} \
        | tee /dev/stderr \
        | grep 'simple has address ${nodes.simple.networking.primaryIPAddress}'
      """)

    # simple can resolve itself without specifying server
    simple.succeed("""
      host simple \
        | tee /dev/stderr \
        | grep 'simple has address ${nodes.simple.networking.primaryIPAddress}'
      """)

    # simple can be resolved on a different host (without specifying server)
    hostname.succeed("""
      host simple \
        | tee /dev/stderr \
        | grep 'simple has address ${nodes.simple.networking.primaryIPAddress}'
      """)

    # custom-hostname can be resolved on a different host (without specifying server)
    simple.succeed("""
      host custom-hostname \
        | tee /dev/stderr \
        | grep 'custom-hostname has address ${nodes.hostname.networking.primaryIPAddress}'
      """)

    simple.succeed("""
      ! host overridedns
      """)
    simple.succeed("""
      host overriddendns
      """)

    simple.succeed("""
      host extradns \
        | tee /dev/stderr \
        | grep 'extradns has address ${nodes.extradns.networking.primaryIPAddress}'
      """)
    simple.succeed("""
      host an-extra-name \
        | tee /dev/stderr \
        | grep 'an-extra-name has address ${nodes.extradns.networking.primaryIPAddress}'
      """)

    simple.succeed("""
      host indomain.thedomain \
        | tee /dev/stderr \
        | grep 'indomain.thedomain has address ${nodes.indomain.networking.primaryIPAddress}'
      """)

  '';
}
