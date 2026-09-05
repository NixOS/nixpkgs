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

    # Generating the first config
    machine.succeed("nixos-secrets generate -f /etc/nixos/config1.nix")
    t.assertEqual("Hewwo placeholder!", machine.succeed("cat /tmp/secrets-demo/generators/greeting/files/greeting").strip())
    t.assertIn("< Hewwo placeholder! >", machine.succeed("cat /tmp/secrets-demo/generators/derived/files/derived"))

    # Switching to the second config
    machine.succeed("nixos-secrets collect-garbage -f /etc/nixos/config2.nix")
    machine.succeed("test ! -f /tmp/secrets-demo/generators/derived/files/derived")
    machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix")
    t.assertIn("< Hewwo placeholder! >", machine.succeed("cat /tmp/secrets-demo/generators/derived/files/derived2"))

    # Should work without a sandbox
    machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix")
    t.assertIn("< Hewwo placeholder! >", machine.succeed("cat /tmp/secrets-demo/generators/derived/files/derived2"))

    # Should be a no-op (there's no garbage to collect)
    machine.succeed("nixos-secrets collect-garbage -f /etc/nixos/config2.nix ")

    # "derived" depends on "greeting"
    t.assertIn("Successfully updated 1 secret(s).", machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix -g derived"))
    t.assertIn("Successfully updated 2 secret(s).", machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix -g greeting"))
    t.assertIn("Successfully updated 2 secret(s).", machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix -g greeting -g derived"))

    # Local deployments
    machine.succeed("mkdir /tmp/system")
    machine.succeed("nixos-secrets deploy -l /tmp/system -f /etc/nixos/config2.nix")
    t.assertIn("Hewwo placeholder!!", machine.succeed("cat /tmp/system/tmp/secrets-demo/greeting/greeting"))
    t.assertIn("< Hewwo placeholder!! >", machine.succeed("cat /tmp/system/tmp/secrets-demo/derived/derived2"))

    # --set
    machine.succeed("mkdir /tmp/greeting-files")
    machine.succeed("echo 'green orange' > /tmp/greeting-files/greeting")
    machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix --set greeting=/tmp/greeting-files")
    t.assertIn("green orange", machine.succeed("cat /tmp/secrets-demo/generators/greeting/files/greeting"))
    t.assertIn("< green orange >", machine.succeed("cat /tmp/secrets-demo/generators/derived/files/derived2"))

    # This script is written to always fail!
    machine.fail("nixos-secrets deploy -f /etc/nixos/config2.nix")
  '';
}
