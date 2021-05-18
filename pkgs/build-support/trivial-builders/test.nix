{ lib, nixosTest, path, writeText, hello, figlet, stdenvNoCC }:

nixosTest {
  name = "nixpkgs-trivial-builders";
  nodes.machine = { ... }: {
    virtualisation.writableStore = true;

    # Test runs without network, so we don't substitute and prepare our deps
    nix.binaryCaches = lib.mkForce [];
    environment.etc."pre-built-paths".source = writeText "pre-built-paths" (
      builtins.toJSON [hello figlet stdenvNoCC]
    );
  };
  testScript = ''
    machine.succeed("""
      cd ${lib.cleanSource path}
      ./pkgs/build-support/trivial-builders/test.sh 2>/dev/console
    """)
  '';
}
