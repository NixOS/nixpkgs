{
  lib,
  autopen,
}:

let
  inherit (lib)
    hashString
    unsafeGetAttrPos
    ;

  inherit (autopen.internal)
    hideDerivation
    mkAutopenDerivation
    ;

  /**
    Produce a fake derivation object with a given `outPath`.

    This differs from `lib.toDerivation` in that it does not depend on
    `storePaths`.

    # Inputs

    `outPath`
    : The output path for the derivation.

    `attrs`
    : Any additional attributes to include in the derivation.

    # Type

    ```
    fakeDerivation :: String -> AttrSet -> Derivation
    ```
  */
  fakeDerivation =
    outPath: attrs:
    let
      drv = {
        type = "derivation";

        outputs = [ "out" ];
        out = drv;
        all = [ drv ];
        outputName = "out";

        inherit outPath;
      }
      // attrs;
    in
    drv;
in
{
  /**
    Import a signing key from an existing path.

    ::: {.warning}
    The contents of the path will be copied into the store; **this is
    insecure to use with software keys**.

    Outside of testing, you should use remote keys that do not
    contain private key material, likely through
    `autopen.signingKey.remote`.
    :::

    # Inputs

    `name`
    : The name to use for the signing key derivation.

    `path`
    : The path containing the signing key.

    `pos` (optional)
    : The position for the signing key derivation.

    `meta` (optional)
    : The metadata for the signing key derivation.

    # Type

    ```
    import ::
      {
        name :: String,
        path :: Path | Derivation,
        pos :: { file :: String, line :: Int } | Null,
        meta :: AttrSet,
      } -> SigningKey
    ```
  */
  import =
    {
      name,
      path,
      pos ? unsafeGetAttrPos "name" args,
      meta ? { },
    }@args:
    let
      signingKey = fakeDerivation "${path}" {
        inherit name verificationKey;
        meta = meta // {
          ${if pos != null then "position" else null} = "${pos.file}:${toString pos.line}";
        };
      };

      verificationKey = hideDerivation (mkAutopenDerivation {
        name = "${name}-verification-key";

        autopenArgs = [
          "signing-key"
          "get-verification-key"
          {
            inherit signingKey;
            output = placeholder "out";
          }
        ];

        inherit pos;

        meta = meta // {
          ${if meta ? description then "description" else null} = "${meta.description} (verification key)";
        };
      });
    in
    signingKey;

  /**
    Create a remote signing key.

    These are stubs that reference signing keys accessible through
    a remote server (see `autopen signing-key remote` and
    `autopen serve`).

    # Inputs

    `name`
    : The name to use for the signing key derivation.

    `socketPath` (optional, default: `"/run/autopen/socket"`)
    : The path to the autopen server’s Unix socket inside the Nix
      build environment.

    `verificationKey`
    : The path to the verification key file corresponding to the
      signing key.

    `pos` (optional)
    : The position for the signing key derivation.

    `meta` (optional)
    : The metadata for the signing key derivation.

    # Type

    ```
    remote ::
      {
        name :: String,
        socketPath :: String,
        verificationKey :: VerificationKey,
        pos :: { file :: String, line :: Int } | Null,
        meta :: AttrSet,
      } -> SigningKey
    ```
  */
  remote =
    {
      name,
      socketPath ? "/run/autopen/socket",
      verificationKey,
      pos ? unsafeGetAttrPos "name" args,
      meta ? { },
    }@args:
    let
      verificationKey = fakeDerivation "${args.verificationKey}" {
        name = "${name}-verification-key";

        meta = meta // {
          ${if meta ? description then "description" else null} = "${meta.description} (verification key)";
          ${if pos != null then "position" else null} = "${pos.file}:${toString pos.line}";
        };
      };

      # We need a store path to use as a file reference for the
      # remote key.
      #
      # Ideally, this would be an unforgeable capability
      # passed down from the builder’s autopen configuration. The
      # best we can do with Nix as it exists is to create a store
      # path that is stable and unique for a given remote key
      # configuration.
      #
      # The fundamental property this ensures is that derivations
      # that don’t include this store path in their build‐time
      # closure cannot use the corresponding key. This preserves the
      # fundamental guarantees of the Nix model, and lets us expose
      # signing capabilities inside the build sandbox without letting
      # arbitrary packages with compromised upstreams sign anything.
      #
      # We can’t stop derivations that shouldn’t have
      # access to this from reconstructing it independently for a
      # given key configuration, but this and the `drvPath` hole can
      # be detected by CI. In any case, this is more a matter of
      # defence‐in‐depth; the capability model of autopen is not
      # intended as a strong protection against a compromise of
      # Nixpkgs itself.
      #
      # We use an empty directory here, as files can could be subject
      # to a hard‐linking attack via store optimization.
      fileRefPath = builtins.path {
        path = ./.;
        name = "${name}-key-handle-${hashString "sha256" "${verificationKey}"}";
        filter = _: _: false;
      };
    in
    mkAutopenDerivation {
      name = "${name}-signing-key";

      autopenArgs = [
        "signing-key"
        "remote"
        "create"
        {
          inherit socketPath fileRefPath verificationKey;
          output = placeholder "out";
        }
      ];

      allowedRequisites = [
        "out"
        fileRefPath
      ];

      passthru = {
        inherit socketPath fileRefPath verificationKey;
      };

      inherit pos meta;
    };
}
