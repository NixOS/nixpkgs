import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "replace-dependencies";
    meta.maintainers = [ ];

    nodes.machine =
      { ... }:
      {
        nix.settings.experimental-features = [ "ca-derivations" ];
        nix.enable = true; # disabled by default. See all-tests.nix / tag(no-nix-by-default)

        system.extraDependencies = [ pkgs.stdenvNoCC ];
      };

    testScript = ''
      start_all()
      machine.succeed("nix-build --option substitute false ${pkgs.path}/nixos/tests/replace-dependencies/guest.nix")
    '';
  }
)
