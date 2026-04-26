{ callPackage }:

let
  mkBrave = release: callPackage ./make-brave.nix { } (import release);
in
{
  brave = mkBrave ./packages/brave.nix;
  brave-beta = mkBrave ./packages/brave-beta.nix;
  brave-nightly = mkBrave ./packages/brave-nightly.nix;
  brave-origin-beta = mkBrave ./packages/brave-origin-beta.nix;
  brave-origin-nightly = mkBrave ./packages/brave-origin-nightly.nix;
}
