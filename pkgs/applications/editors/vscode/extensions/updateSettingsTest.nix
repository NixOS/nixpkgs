with import <nixpkgs> { };
callPackage (import ./updateSettings.nix) { } {
  settings = {
    a = "fdsdf";
  };
}
