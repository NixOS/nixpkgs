{
  callPackage,
  ...
}:

let
  mkIrohPackage = callPackage ./irohPackage.nix { };
in
mkIrohPackage {
  targetBinary = "iroh-dns-server";
}
