let
  mirrors = import ./mirrors.nix;
  inherit (builtins)
    elemAt
    head
    isString
    match
    ;
in

{
  rewriteURL,
  system,
}:
let
  handleUrl =
    if rewriteURL == null then
      url: url
    else
      url:
      let
        u = rewriteURL url;
      in
      if isString u then
        u
      else
        throw "rewriteURL deleted the only URL passed to fetchurlBoot (was ${url})";
in
{
  url ? head urls,
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
      url_ = handleUrl url;
      m = match "mirror://([a-z]+)/(.*)" url_;
    in
    if m == null then url_ else head (mirrors.${head m}) + (elemAt m 1);
}
