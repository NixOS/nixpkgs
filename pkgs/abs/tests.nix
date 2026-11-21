# Run:
#   nix-shell -p nix-unit -I nixpkgs=.
#   nix-unit pkgs/abs/tests.nix
#
# See also pkgs/test/top-level/default.nix
let
  nixpkgs = import ./default.nix;

  legacyEntrypoint = import ../..;
in
{
  "test native invocation matches legacy entrypoint" = {
    expr = (nixpkgs.configure {
      hostPlatform.system = "x86_64-linux";
    }).hello.outPath;
    expected = (legacyEntrypoint {
      localSystem.system = "x86_64-linux";
    }).hello.outPath;
  };
  "test cross invocation matches legacy entrypoint" = {
    expr = (nixpkgs.configure {
      buildPlatform = "aarch64-linux";
      hostPlatform = "x86_64-linux";
    }).hello.outPath;
    expected = (legacyEntrypoint {
      localSystem.system = "aarch64-linux";
      crossSystem.system = "x86_64-linux";
    }).hello.outPath;
  };
}
