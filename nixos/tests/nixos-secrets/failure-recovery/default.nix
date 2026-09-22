{
  name = "nixos-secrets-failure-recovery";

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
        (import ../collect-secrets-scripts.nix {
          inherit pkgs;
          configuration = ./config/config3.nix;
        })
      ];
    };

  testScript = ''
    machine.wait_for_unit("default.target")

    # Generate the first config
    machine.succeed("nixos-secrets generate -f /etc/nixos/config1.nix")
    t.assertEqual("Hewwo world :3", machine.succeed("cat /tmp/secrets/generators/greeting/files/greeting").strip())
    t.assertIn("< Hewwo world :3 >", machine.succeed("cat /tmp/secrets/generators/derived/files/cow-greeting"))

    # Switch to the second config ('derived' is intentionally broken)
    msg = machine.fail("nixos-secrets generate -f /etc/nixos/config2.nix -g greeting")
    # This one was forced
    t.assertIn("Generating 'greeting'", msg)
    t.assertEqual("Hewwo world :3c", machine.succeed("cat /tmp/secrets/generators/greeting/files/greeting").strip())
    # 'derived' depends on 'greeting'
    t.assertIn("Generating 'derived'", msg)
    # Since the 'fail' backend made 'derived' fail, this will contain the old version
    t.assertIn("< Hewwo world :3 >", machine.succeed("cat /tmp/secrets/generators/derived/files/cow-greeting").strip())

    # Switch to the third config ('derived' goes back to the initial config)
    msg = machine.succeed("nixos-secrets generate -f /etc/nixos/config3.nix")
    # There's no reason to regenerate this one
    t.assertIn("Skipping 'greeting'", msg)
    # This one failed last time, so it will be regenerated
    t.assertIn("Generating 'derived'", msg)
    t.assertIn("< Hewwo world :3c >", machine.succeed("cat /tmp/secrets/generators/derived/files/cow-greeting"))
  '';
}
