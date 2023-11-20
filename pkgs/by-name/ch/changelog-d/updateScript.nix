{ writeShellApplication, cabal2nix }:

writeShellApplication {
  name = "update-changelog-d";
  runtimeInputs = [
    cabal2nix
  ];
  text = ''
    cd pkgs/development/misc/haskell/changelog-d
    cabal2nix https://codeberg.org/fgaz/changelog-d >default.nix
  '';
}
