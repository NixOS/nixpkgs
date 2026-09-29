{
  lib,
  stdenvNoCC,
  writeText,
  autopen,
  testSignedPackages,
  linkFarm,
  runCommand,
  openssl_4_0,
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

  signedPackages = testSignedPackages.override {
    uefiSigningKey = signingKey;
  };
in
linkFarm "autopen-test" (
  {
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

    certificate-check =
      runCommand "autopen-test-certificate-check"
        {
          nativeBuildInputs = [
            # Versions prior to 4.0 suffer from
            # <https://github.com/openssl/openssl/issues/15124>…
            openssl_4_0
          ];
          inherit (signedPackages) uefiCertificate;
          strictDeps = true;
          __structuredAttrs = true;
        }
        ''
          exec &> >(tee -- "$out")
          openssl asn1parse -in "$uefiCertificate" -inform DER -i
          openssl x509 -in "$uefiCertificate" -noout -text
          openssl verify \
            -verbose \
            -CAfile "$uefiCertificate" \
            -attime "$(date --date=1970-01-01T23:59:59Z +%s)" \
            -check_ss_sig \
            -x509_strict \
            -- "$uefiCertificate"
        '';
  }
  // lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux (
    lib.filterAttrs (_: lib.isDerivation) signedPackages
  )
)
