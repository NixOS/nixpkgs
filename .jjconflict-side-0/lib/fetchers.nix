# snippets that can be shared by multiple fetchers (pkgs/build-support)
{ lib }:
let
  commonH = hashTypes: rec {
      hashNames = [ "hash" ] ++ hashTypes;
      hashSet = lib.genAttrs hashNames (lib.const {});
  };

  fakeH = {
    hash = lib.fakeHash;
    sha256 = lib.fakeSha256;
    sha512 = lib.fakeSha512;
  };
in rec {

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

    An appropriate “fake hash” is substituted when the hash value is `""`,
    as is the [convention for fetchers](#sec-pkgs-fetchers-updating-source-hashes-fakehash-method).

    All other attributes in the set remain as-is.

    # Example

    ```nix
    normalizeHash { } { hash = ""; foo = "bar"; }
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
  }:
    let
      inherit (lib) concatMapStringsSep head tail throwIf;
      inherit (lib.attrsets) attrsToList intersectAttrs removeAttrs optionalAttrs;

      inherit (commonH hashTypes) hashNames hashSet;
    in
      args:
        if args ? "outputHash" then
          args
        else
          let
            # The argument hash, as a {name, value} pair
            h =
              # All hashes passed in arguments (possibly 0 or >1) as a list of {name, value} pairs
              let hashesAsNVPairs = attrsToList (intersectAttrs hashSet args); in
              if hashesAsNVPairs == [] then
                throwIf required "fetcher called without `hash`" null
              else if tail hashesAsNVPairs != [] then
                throw "fetcher called with mutually-incompatible arguments: ${concatMapStringsSep ", " (a: a.name) hashesAsNVPairs}"
              else
                head hashesAsNVPairs
            ;
          in
            removeAttrs args hashNames // (optionalAttrs (h != null) {
              outputHashAlgo = if h.name == "hash" then null else h.name;
              outputHash =
                if h.value == "" then
                  fakeH.${h.name} or (throw "no “fake hash” defined for ${h.name}")
                else
                  h.value;
            })
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
    let
      inherit (lib.attrsets) genAttrs intersectAttrs removeAttrs;
      inherit (lib.trivial) const functionArgs setFunctionArgs;

      inherit (commonH hashTypes) hashSet;
      fArgs = functionArgs fetcher;

      normalize = normalizeHash {
        inherit hashTypes;
        required = !fArgs.outputHash;
      };
    in
    # The o.g. fetcher must *only* accept outputHash and outputHashAlgo
    assert fArgs ? outputHash && fArgs ? outputHashAlgo;
    assert intersectAttrs fArgs hashSet == {};

    setFunctionArgs
      (args: fetcher (normalize args))
      (removeAttrs fArgs [ "outputHash" "outputHashAlgo" ] // { hash = fArgs.outputHash; });
}
