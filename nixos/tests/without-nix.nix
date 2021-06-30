{
  system ? builtins.currentSystem,
  pkgsFun ? args: import ../.. ({ inherit system; config = {}; } // args),
  ...
} @ args:

let
  # We could simply use the `nixpkgs.overlays` NixOS option, but this more
  # throughly excises Nix at eval time.
  pkgs = pkgsFun {
    overlays = [
      (self: super: {
        nix = throw "don't want to use this";
      })
    ];
  };
in

with import ../lib/testing-python.nix { inherit system pkgs; };

makeTest {
  name = "without-nix";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ericson2314 ];
  };

  nodes.machine = { ... }: {
    nix.enable = false;
  };

  testScript = ''
    start_all()

    machine.succeed("which which")
    machine.fail("which nix")
  '';
}
