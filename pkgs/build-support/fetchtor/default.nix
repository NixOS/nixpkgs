{
  lib,
  fetchgit,
  fetchurl,
  fetchzip,
  tor,
}:
let
  defaultFetcherFromUrl =
    url:
    if
      lib.hasSuffix ".tar" url
      || lib.hasSuffix ".tar.bz" url
      || lib.hasSuffix ".tar.gz" url
      || lib.hasSuffix ".tar.xz" url
      || lib.hasSuffix ".tgz" url
      || lib.hasSuffix ".zip" url
    then
      fetchzip
    else
      fetchurl;
in
{
  /**
    The underlying fetcher to use over Tor.

    This defaults to fetchgit if a rev attribute is specified, fetchzip if
    the URL looks like an archive, and fetchurl otherwise; but in theory you
    can set it to any fetcher that honors curl's ALL_PROXY and NO_PROXY
    environment variables.
  */
  fetcher ? if args ? rev then fetchgit else defaultFetcherFromUrl (lib.toLower args.url),

  /**
    A list of domains not to proxy through Tor.

    This is useful when using fetchgit and there are submodules that are
    accessible from the clearnet.
  */
  noTor ? [ ],
  ...
}@args:

(fetcher (
  removeAttrs args [
    "fetcher"
    "noTor"
  ]
)).overrideAttrs
  (prevAttrs: {
    nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ tor ];
    builder = ./builder.sh;
    innerBuilder = prevAttrs.builder;
    inherit noTor;
  })
