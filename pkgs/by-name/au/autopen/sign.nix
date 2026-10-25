{
  lib,
  autopen,
}:

let
  inherit (lib)
    unsafeGetAttrPos
    ;

  inherit (autopen.internal)
    hideDerivation
    mkAutopenDerivation
    ;
in

/**
  Sign a message with a signing key.

  # Inputs

  `signingKey`
  : The signing key to use.

  `message`
  : The path to the message to sign.

  `pos` (optional)
  : The position for the signature derivation.

  `meta` (optional)
  : The metadata for the signature derivation.

  # Type

  ```
  sign ::
    {
      signingKey :: SigningKey,
      message :: StorePath,
      pos :: { file :: String, line :: Int } | Null,
      meta :: AttrSet,
    } -> Derivation
  ```
*/
{
  signingKey,
  message,
  pos ? unsafeGetAttrPos "message" args,
  meta ? { },
}@args:
hideDerivation (mkAutopenDerivation {
  name = "${message.name}.sig";

  inherit signingKey message;

  autopenArgs = [
    "sign"
    {
      inherit signingKey;
      output = placeholder "out";
    }
    message
  ];

  # Keys shouldn’t propagate to outputs.
  allowedRequisites = [ "out" ];

  passthru = {
    # TODO: This is technically a little strange in terms of the
    # cryptographic semantics, but it’s convenient.
    inherit message;
  };

  inherit pos meta;
})
