{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

with import common/ec2.nix { inherit makeTest pkgs; };

let
  image =
    (import ../lib/eval-config.nix {
      inherit system;
      modules = [
        ../maintainers/scripts/openstack/openstack-image.nix
        ../modules/testing/test-instrumentation.nix
        ../modules/profiles/qemu-guest.nix
        {
          # Needed by nixos-rebuild due to lack of network access.
          system.extraDependencies = with pkgs; [
            stdenv
          ];
        }
      ];
    }).config.system.build.openstackImage
    + "/nixos.qcow2";

  sshKeys = import ./ssh-keys.nix pkgs;
  snakeOilPrivateKey = sshKeys.snakeOilPrivateKey.text;
  snakeOilPrivateKeyFile = pkgs.writeText "private-key" snakeOilPrivateKey;
  snakeOilPublicKey = sshKeys.snakeOilPublicKey;

in
{
  metadata = makeEc2Test {
    name = "openstack-ec2-metadata";
    inherit image;
    sshPublicKey = snakeOilPublicKey;
    userData = ''
      SSH_HOST_ED25519_KEY_PUB:${snakeOilPublicKey}
      SSH_HOST_ED25519_KEY:${replaceStrings [ "\n" ] [ "|" ] snakeOilPrivateKey}
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
      machine.succeed("ssh -o BatchMode=yes localhost exit")

      # Just to make sure resizing is idempotent.
      machine.shutdown()
      machine.start()
      machine.wait_for_file("/etc/ec2-metadata/user-data")
    '';
  };

  userdata = makeEc2Test {
    name = "openstack-ec2-metadata";
    inherit image;
    sshPublicKey = snakeOilPublicKey;
    userData = ''
      { pkgs, ... }:
      {
        imports = [
          <nixpkgs/nixos/modules/virtualisation/openstack-config.nix>
          <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
          <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
        ];
        environment.etc.testFile = {
          text = "whoa";
        };
      }
    '';
    script = ''
      machine.start()
      machine.wait_for_file("/etc/testFile")
      assert "whoa" in machine.succeed("cat /etc/testFile")
    '';
  };
}
