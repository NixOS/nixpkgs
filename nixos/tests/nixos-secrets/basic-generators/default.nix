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
    machine.succeed("nixos-secrets generate -f /etc/nixos/config1.nix")
    t.assertEqual("Hewwo placeholder!", machine.succeed("cat /tmp/secrets-demo/generators/example/files/example").strip())
    t.assertIn("< Hewwo placeholder! >", machine.succeed("cat /tmp/secrets-demo/generators/derived/files/derived"))

    machine.succeed("nixos-secrets collect-garbage -f /etc/nixos/config2.nix")
    machine.succeed("test ! -f /tmp/secrets-demo/generators/derived/files/derived")

    machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix")
    t.assertIn("< Hewwo placeholder! >", machine.succeed("cat /tmp/secrets-demo/generators/derived/files/derived2"))

    # Should be a no-op
    machine.succeed("nixos-secrets collect-garbage -f /etc/nixos/config2.nix ")

    # "derived" depends on "example"
    t.assertIn("Successfully (re)run 1 generator(s).", machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix -g derived"))
    t.assertIn("Successfully (re)run 2 generator(s).", machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix -g example"))
    t.assertIn("Successfully (re)run 2 generator(s).", machine.succeed("nixos-secrets generate -f /etc/nixos/config2.nix -g example -g derived"))

    machine.succeed("mkdir /tmp/system")
    machine.succeed("nixos-secrets deploy -l /tmp/system -f /etc/nixos/config2.nix")
    t.assertIn("Hewwo placeholder!!", machine.succeed("cat /tmp/system/tmp/secrets-demo/example/example"))
    t.assertIn("< Hewwo placeholder!! >", machine.succeed("cat /tmp/system/tmp/secrets-demo/derived/derived2"))

    # We haven't yet implemented this!
    machine.fail("nixos-secrets deploy -f /etc/nixos/config2.nix")
  '';
}
