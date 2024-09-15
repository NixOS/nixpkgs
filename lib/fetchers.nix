# snippets that can be shared by multiple fetchers (pkgs/build-support)
{ lib }:
rec {

  proxyImpureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
    "HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" "ALL_PROXY" "NO_PROXY"

    # https proxies typically need to inject custom root CAs too
    "NIX_SSL_CERT_FILE"
  ];

  /**
    Converts an attrset containing one of `hash`, `sha256` or `sha512`,
    into one containing `outputHash{,Algo}` as accepted by `mkDerivation`.

    All other attributes in the set remain as-is.

    # Example

    ```nix
    normalizeHash { } { hash = lib.fakeHash; foo = "bar"; }
    =>
    {
      outputHash = lib.fakeHash;
      outputHashAlgo = null;
      foo = "bar";
    }
    ```

    ```nix
    normalizeHash { } { sha256 = lib.fakeSha256; }
    =>
    {
      outputHash = lib.fakeSha256;
      outputHashAlgo = "sha256";
    }
    ```

    ```nix
    normalizeHash { } { sha512 = lib.fakeSha512; }
    =>
    {
      outputHash = lib.fakeSha512;
      outputHashAlgo = "sha512";
    }
    ```

    # Type
    ```
    normalizeHash :: { hashTypes :: List String, required :: Bool } -> AttrSet -> AttrSet
    ```

    # Arguments

    hashTypes
    : the set of attribute names accepted as hash inputs, in addition to `hash`

    required
    : whether to throw if no hash was present in the input; otherwise returns the original input, unmodified
  */
  normalizeHash = {
    hashTypes ? [ "sha256" ],
    required ? true,
  }: args:
    with builtins; with lib;
    let
      hNames = [ "hash" ] ++ hashTypes;

      # The argument hash, as a {name, value} pair
      h =
        let _h = attrsToList (intersectAttrs (genAttrs hNames (const {})) args); in
        if _h == [] then
          throw "fetcher called without `hash`"
        else if tail _h != [] then
          throw "fetcher called with mutually-incompatible arguments: ${concatMapStringsSep ", " (a: a.name) _h}"
        else
          head _h
      ;
    in
      if args ? "outputHash" then
        args
      else
        removeAttrs args hNames // {
          outputHash = h.value;
          outputHashAlgo = if h.name == "hash" then null else h.name;
        }
  ;

  /**
    Wraps a function which accepts `outputHash{,Algo}` into one which accepts `hash` or `sha{256,512}`

    # Example
    ```nix
    withNormalizedHash { hashTypes = [ "sha256" "sha512" ]; } (
      { outputHash, outputHashAlgo, ... }:
      ...
    )
    ```
    is a function which accepts one of `hash`, `sha256`, or `sha512` (or the original's `outputHash` and `outputHashAlgo`).

    Its `functionArgs` metadata only lists `hash` as a parameter, optional iff. `outputHash` was an optional parameter of
    the original function.  `sha256`, `sha512`, `outputHash`, or `outputHashAlgo` are not mentioned in the `functionArgs`
    metadata.

    # Type
    ```
    withNormalizedHash :: { hashTypes :: List String } -> (AttrSet -> T) -> (AttrSet -> T)
    ```

    # Arguments

    hashTypes
    : the set of attribute names accepted as hash inputs, in addition to `hash`
    : they must correspond to a valid value for `outputHashAlgo`, currently one of: `md5`, `sha1`, `sha256`, or `sha512`.

    f
    : the function to be wrapped

    ::: {.note}
    In nixpkgs, `mkDerivation` rejects MD5 `outputHash`es, and SHA-1 is being deprecated.

    As such, there is no reason to add `md5` to `hashTypes`, and
    `sha1` should only ever be included for backwards compatibility.
    :::

    # Output

    `withNormalizedHash { inherit hashTypes; } f` is functionally equivalent to
    ```nix
    args: f (normalizeHash {
      inherit hashTypes;
      required = !(lib.functionArgs f).outputHash;
    } args)
    ```

    However, `withNormalizedHash` preserves `functionArgs` metadata insofar as possible,
    and is implemented somewhat more efficiently.
  */
  withNormalizedHash = {
    hashTypes ? [ "sha256" ]
  }: fetcher:
    with builtins; with lib;
    let
      hAttrs = genAttrs ([ "hash" ] ++ hashTypes) (const {});
      fArgs = functionArgs fetcher;
    in
    # The o.g. fetcher must *only* accept outputHash and outputHashAlgo
    assert !fArgs.outputHash && !fArgs.outputHashAlgo;
    assert intersectAttrs fArgs hAttrs == {};

    setFunctionArgs
      (args: fetcher (normalizeHash { inherit hashTypes; } args))
      (removeAttrs fArgs [ "outputHash" "outputHashAlgo" ] // { hash = false; });
}
