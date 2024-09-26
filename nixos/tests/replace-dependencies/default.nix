import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "replace-dependencies";
    meta.maintainers = with pkgs.lib.maintainers; [ alois31 ];

    nodes.machine =
      { ... }:
      {
        nix.settings.experimental-features = [ "ca-derivations" ];
        system.extraDependencies = [ pkgs.stdenvNoCC ];
      };

    testScript = ''
      start_all()
      machine.succeed("nix-build --option substitute false ${pkgs.path}/nixos/tests/replace-dependencies/guest.nix")
    '';
  }
)
