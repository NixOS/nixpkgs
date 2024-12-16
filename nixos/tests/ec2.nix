{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

with import common/ec2.nix { inherit makeTest pkgs; };

let
  imageCfg = (import ../lib/eval-config.nix {
    inherit system;
    modules = [
      ../maintainers/scripts/ec2/amazon-image.nix
      ../modules/testing/test-instrumentation.nix
      ../modules/profiles/qemu-guest.nix
      {
        # Hack to make the partition resizing work in QEMU.
        boot.initrd.postDeviceCommands = mkBefore ''
          ln -s vda /dev/xvda
          ln -s vda1 /dev/xvda1
        '';

        amazonImage.format = "qcow2";

        # In a NixOS test the serial console is occupied by the "backdoor"
        # (see testing/test-instrumentation.nix) and is incompatible with
        # the configuration in virtualisation/amazon-image.nix.
        systemd.services."serial-getty@ttyS0".enable = mkForce false;
      }
    ];
  }).config;
  image = "${imageCfg.system.build.amazonImage}/${imageCfg.amazonImage.name}.qcow2";

  sshKeys = import ./ssh-keys.nix pkgs;
  snakeOilPrivateKey = sshKeys.snakeOilPrivateKey.text;
  snakeOilPrivateKeyFile = pkgs.writeText "private-key" snakeOilPrivateKey;
  snakeOilPublicKey = sshKeys.snakeOilPublicKey;

in {
  ec2-nixops = makeEc2Test {
    name         = "nixops-userdata";
    meta.timeout = 600;
    inherit image;
    sshPublicKey = snakeOilPublicKey; # That's right folks! My user's key is also the host key!

    userData = ''
      SSH_HOST_ED25519_KEY_PUB:${snakeOilPublicKey}
      SSH_HOST_ED25519_KEY:${replaceStrings ["\n"] ["|"] snakeOilPrivateKey}
    '';
    script = ''
      machine.start()
      machine.wait_for_file("/etc/ec2-metadata/user-data")
      machine.wait_for_unit("sshd.service")

      machine.succeed("grep unknown /etc/ec2-metadata/ami-manifest-path")

      # We have no keys configured on the client side yet, so this should fail
      machine.fail("ssh -o BatchMode=yes localhost exit")

      # Let's install our client private key
      machine.succeed("mkdir -p ~/.ssh")

      machine.copy_from_host_via_shell(
          "${snakeOilPrivateKeyFile}", "~/.ssh/id_ed25519"
      )
      machine.succeed("chmod 600 ~/.ssh/id_ed25519")

      # We haven't configured the host key yet, so this should still fail
      machine.fail("ssh -o BatchMode=yes localhost exit")

      # Add the host key; ssh should finally succeed
      machine.succeed(
          "echo localhost,127.0.0.1 ${snakeOilPublicKey} > ~/.ssh/known_hosts"
      )
      machine.succeed("ssh -o BatchMode=yes localhost exit", timeout=120)

      # Test whether the root disk was resized.
      blocks, block_size = map(int, machine.succeed("stat -c %b:%S -f /").split(":"))
      GB = 1024 ** 3
      assert 9.7 * GB <= blocks * block_size <= 10 * GB

      # Just to make sure resizing is idempotent.
      machine.shutdown()
      machine.start()
      machine.wait_for_file("/etc/ec2-metadata/user-data")
    '';
  };
}
