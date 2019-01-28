{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

with import common/ec2.nix { inherit makeTest pkgs; };

let
  image =
    (import ../lib/eval-config.nix {
      inherit system;
      modules = [
        ../maintainers/scripts/openstack/nova-image.nix
        ../modules/testing/test-instrumentation.nix
        ../modules/profiles/qemu-guest.nix
      ];
    }).config.system.build.novaImage;

in
  makeEc2Test {
    name         = "nova-ec2-metadata";
    inherit image;
    sshPublicKey = snakeOilPublicKey; # That's right folks! My user's key is also the host key!

    userData = ''
      SSH_HOST_ED25519_KEY_PUB:${snakeOilPublicKey}
      SSH_HOST_ED25519_KEY:${replaceStrings ["\n"] ["|"] snakeOilPrivateKey}
    '';
    script = ''
      $machine->start;
      $machine->waitForFile("/etc/ec2-metadata/user-data");
      $machine->waitForUnit("sshd.service");

      $machine->succeed("grep unknown /etc/ec2-metadata/ami-manifest-path");

      # We have no keys configured on the client side yet, so this should fail
      $machine->fail("ssh -o BatchMode=yes localhost exit");

      # Let's install our client private key
      $machine->succeed("mkdir -p ~/.ssh");

      $machine->succeed("echo '${snakeOilPrivateKey}' > ~/.ssh/id_ed25519");
      $machine->succeed("chmod 600 ~/.ssh/id_ed25519");

      # We haven't configured the host key yet, so this should still fail
      $machine->fail("ssh -o BatchMode=yes localhost exit");

      # Add the host key; ssh should finally succeed
      $machine->succeed("echo localhost,127.0.0.1 ${snakeOilPublicKey} > ~/.ssh/known_hosts");
      $machine->succeed("ssh -o BatchMode=yes localhost exit");

      # Just to make sure resizing is idempotent.
      $machine->shutdown;
      $machine->start;
      $machine->waitForFile("/etc/ec2-metadata/user-data");
    '';
  }
