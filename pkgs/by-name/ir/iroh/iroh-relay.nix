{
  callPackage,
  ...
}:

let
  mkIrohPackage = callPackage ./irohPackage.nix { };
in
mkIrohPackage {
  features = [ "server" ];
  targetBinary = "iroh-relay";
}
