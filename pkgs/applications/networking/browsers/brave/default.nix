{ callPackage }:

let
  mkBrave = release: callPackage ./make-brave.nix { } (import release);
in
{
  brave = mkBrave ./packages/brave.nix;
}
