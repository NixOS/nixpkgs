let
  mirrors = import ./mirrors.nix;
in

{ system }:

{
  url ? builtins.head urls,
  urls ? [ ],
  sha256 ? "",
  hash ? "",
  name ? baseNameOf (toString url),
}:

# assert exactly one hash is set
assert hash != "" || sha256 != "";
assert hash != "" -> sha256 == "";

import <nix/fetchurl.nix> {
  inherit
    system
    hash
    sha256
    name
    ;

  url =
    # Handle mirror:// URIs. Since <nix/fetchurl.nix> currently
    # supports only one URI, use the first listed mirror.
    let
      m = builtins.match "mirror://([a-z]+)/(.*)" url;
    in
    if m == null then url else builtins.head (mirrors.${builtins.elemAt m 0}) + (builtins.elemAt m 1);
}
