{ ... }: {
  name = "lix";
  nodes.machine = { pkgs, ... }: {
    nix.enable = true; # disabled by default. See all-tests.nix / tag(no-nix-by-default)

    nix.package = pkgs.lix;

    environment.etc."test.nix".text = ''
      derivation {
        name = "test";
        builder = "/bin/sh";
        args = [ "-c" "echo succeeded > $out" ];
        system = "${pkgs.stdenv.hostPlatform.system}";
      }
    '';

    specialisation.experimental-rpc.configuration = { pkgs, lib, ... }: {
      nix.settings.experimental-features = [
        "rpc-sockets"
        "nix-command"
      ];
      nix.package = lib.mkForce pkgs.lixPackageSets.lix_2_96.lix;
    };
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("sockets.target")
    machine.succeed("NIX_REMOTE=daemon nix-build /etc/test.nix")

    with subtest("experimental-rpc"):
      machine.succeed("/run/current-system/specialisation/experimental-rpc/bin/switch-to-configuration test")
      machine.succeed("NIX_REMOTE='daemon?protocol=lix-xp-1' nix store ping")
  '';
}
