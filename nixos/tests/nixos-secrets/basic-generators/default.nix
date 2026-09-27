{
  name = "nixos-secrets-basic-generators";

  nodes.machine =
    { pkgs, ... }:
    {
      nix.nixPath = [ "nixpkgs=${pkgs.path}" ];
      environment.systemPackages = [ pkgs.nixos-secrets ];
      environment.etc."nixos".source = ./config;

      system.extraDependencies = [
        (import ../collect-secrets-scripts.nix {
          inherit pkgs;
          configuration = ./config/config1.nix;
        })
        (import ../collect-secrets-scripts.nix {
          inherit pkgs;
          configuration = ./config/config2.nix;
        })
      ];
    };

  testScript = ''
    machine.wait_for_unit("default.target")

    # We ensure this works even if there's nothing there to garbage collect
    machine.succeed("nixos-secrets collect-garbage -f /etc/nixos/config1.nix")

    # Generate the first config
    machine.succeed("nixos-secrets generate -f /etc/nixos/config1.nix")
    t.assertEqual("Hewwo placeholder!", machine.succeed("cat /tmp/secrets/generators/greeting/files/greeting").strip())
    t.assertIn("< Hewwo placeholder! >", machine.succeed("cat /tmp/secrets/generators/derived/files/cow-greeting"))

    # Switch to the second config
    machine.succeed("nixos-secrets collect-garbage -f /etc/nixos/config2.nix")
    machine.succeed("test ! -f /tmp/secrets/generators/derived/files/cow-greeting")
    machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix")
    t.assertIn("!redlohecalp owweH", machine.succeed("cat /tmp/secrets/generators/derived/files/reverse-greeting"))

    # Should work without the sandbox
    machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix")
    t.assertIn("!redlohecalp owweH", machine.succeed("cat /tmp/secrets/generators/derived/files/reverse-greeting"))

    # Should be a no-op (there's no garbage to collect)
    machine.succeed("nixos-secrets collect-garbage -f /etc/nixos/config2.nix ")

    # "derived" depends on "greeting"
    t.assertIn("Successfully updated 1 secret(s)", machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix -g derived"))
    t.assertIn("Successfully updated 2 secret(s)", machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix -g greeting"))
    t.assertIn("Successfully updated 2 secret(s)", machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix -g greeting -g derived"))

    # We triggered the rebuild of greeting, so now it has three exclamation marks.
    t.assertEqual("Hewwo placeholder!!!", machine.succeed("cat /tmp/secrets/generators/greeting/files/greeting").strip())

    # Local deployments
    machine.succeed("mkdir /tmp/system")
    machine.succeed("nixos-secrets deploy -l /tmp/system -f /etc/nixos/config2.nix")
    t.assertIn("Hewwo placeholder!!!", machine.succeed("cat /tmp/system/tmp/secrets/greeting/greeting"))
    t.assertIn("!!!redlohecalp owweH", machine.succeed("cat /tmp/system/tmp/secrets/derived/reverse-greeting"))

    # --set
    machine.succeed("mkdir /tmp/greeting-files")
    machine.succeed("echo 'green orange' > /tmp/greeting-files/greeting")
    machine.succeed("nixos-secrets generate -f /etc/nixos/config1.nix --set greeting=/tmp/greeting-files")
    t.assertIn("green orange", machine.succeed("cat /tmp/secrets/generators/greeting/files/greeting"))
    t.assertIn("< green orange >", machine.succeed("cat /tmp/secrets/generators/derived/files/cow-greeting"))

    # --set with a single file
    machine.succeed("echo 'white vanilla' > /tmp/greeting")
    machine.succeed("nixos-secrets generate -f /etc/nixos/config1.nix --set greeting=/tmp/greeting")
    t.assertIn("white vanilla", machine.succeed("cat /tmp/secrets/generators/greeting/files/greeting"))
    t.assertIn("< white vanilla >", machine.succeed("cat /tmp/secrets/generators/derived/files/cow-greeting"))

    # This script is meant to always fail!
    machine.fail("nixos-secrets deploy -f /etc/nixos/config2.nix")
  '';
}
