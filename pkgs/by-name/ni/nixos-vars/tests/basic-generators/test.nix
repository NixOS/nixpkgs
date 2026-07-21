let
  pkgs' = import ../../../../../.. { };
  nix-vars = pkgs: pkgs.python314Packages.callPackage ../../package.nix { };
in

pkgs'.testers.runNixOSTest {
  name = "basic-generators";

  nodes.machine =
    { pkgs, ... }:
    {
      nix.nixPath = [ "nixpkgs=${pkgs.path}" ];
      environment.systemPackages = [ (nix-vars pkgs) ];
      environment.etc."nixos".source = ./config;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      system.extraDependencies = [
        (import ../collect-vars-scripts.nix {
          inherit pkgs;
          config = ./config/config1.nix;
        })
        (import ../collect-vars-scripts.nix {
          inherit pkgs;
          config = ./config/config2.nix;
        })
      ];
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    # We ensure this works even if there's nothing there to garbage collect
    machine.succeed("nix-vars collect-garbage -f /etc/nixos/config1.nix")
    machine.succeed("nix-vars generate -f /etc/nixos/config1.nix")
    t.assertEqual("Hewwo placeholder!", machine.succeed("cat /tmp/vars-demo/generators/example/files/example").strip())
    t.assertIn("< Hewwo placeholder! >", machine.succeed("cat /tmp/vars-demo/generators/derived/files/derived"))

    machine.succeed("nix-vars collect-garbage -f /etc/nixos/config2.nix")
    machine.succeed("test ! -f /tmp/vars-demo/generators/derived/files/derived")

    machine.succeed("nix-vars generate -f /etc/nixos/config2.nix")
    t.assertIn("< Hewwo placeholder! >", machine.succeed("cat /tmp/vars-demo/generators/derived/files/derived2"))

    # Should be a no-op
    machine.succeed("nix-vars collect-garbage -f /etc/nixos/config2.nix ")

    # "derived" depends on "example"
    t.assertIn("Successfully (re)run 1 generator(s).", machine.succeed("nix-vars generate -f /etc/nixos/config2.nix -g derived"))
    t.assertIn("Successfully (re)run 2 generator(s).", machine.succeed("nix-vars generate -f /etc/nixos/config2.nix -g example"))
    t.assertIn("Successfully (re)run 2 generator(s).", machine.succeed("nix-vars generate -f /etc/nixos/config2.nix -g example -g derived"))

    machine.succeed("mkdir /tmp/system")
    machine.succeed("nix-vars deploy -l /tmp/system -f /etc/nixos/config2.nix")
    t.assertIn("< Hewwo placeholder!! >", machine.succeed("cat /tmp/system/tmp/vars-demo/derived/derived2"))

    # We haven't yet implemented this!
    machine.fail("nix-vars deploy -f /etc/nixos/config2.nix")
  '';
}
