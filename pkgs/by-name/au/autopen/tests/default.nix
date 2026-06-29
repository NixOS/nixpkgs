{
  writeText,
  autopen,
  linkFarm,
  runCommand,
}:

{
  signingKey,
}:

let
  message = writeText "autopen-test-message" ''
    squeamish ossifrage
  '';

  signature = autopen.sign {
    inherit signingKey message;
  };
in
linkFarm "autopen-test" {
  inherit signingKey;
  inherit (signingKey) verificationKey;

  inherit message signature;

  signature-check =
    runCommand "autopen-test-signature-check"
      {
        nativeBuildInputs = [
          autopen
        ];
        inherit (signingKey) verificationKey;
        inherit signature message;
        strictDeps = true;
        __structuredAttrs = true;
      }
      ''
        autopen verify \
          --verification-key="$verificationKey" \
          --signature="$signature" \
          -- "$message"
        touch -- "$out"
      '';
}
