let mirrors = import ./mirrors.nix; in

{ system }:

{ url ? builtins.head urls
, urls ? []
, sha256
, name ? baseNameOf (toString url)
}:

import <nix/fetchurl.nix> {
  inherit system sha256 name;

  url =
    # Handle mirror:// URIs. Since <nix/fetchurl.nix> currently
    # supports only one URI, use the first listed mirror.
    let m = builtins.match "mirror://([a-z]+)/(.*)" url; in
    if m == null then url
    else builtins.head (mirrors.${builtins.elemAt m 0}) + (builtins.elemAt m 1);
}
