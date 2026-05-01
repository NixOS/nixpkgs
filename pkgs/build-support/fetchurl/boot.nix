let
  mirrors = import ./mirrors.nix;
in

{
  rewriteURL,
  system,
}:

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
      url_ =
        let
          u = rewriteURL url;
        in
        if builtins.isString u then
          u
        else
          throw "rewriteURL deleted the only URL passed to fetchurlBoot (was ${url})";
      m = builtins.match "mirror://([a-z]+)/(.*)" url_;
    in
    if m == null then url_ else builtins.head (mirrors.${builtins.elemAt m 0}) + (builtins.elemAt m 1);
}
