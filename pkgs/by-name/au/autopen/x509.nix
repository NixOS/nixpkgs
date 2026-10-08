{
  lib,
  autopen,
}:

let
  inherit (lib)
    extendMkDerivation
    unsafeGetAttrPos
    ;

  inherit (autopen)
    sign
    ;

  inherit (autopen.internal)
    mkAutopenDerivation
    ;

  inherit (autopen.x509)
    attachSignature
    mkTbsCertificateForSelfSigning
    ;
in
{
  mkTbsCertificateForSelfSigning = extendMkDerivation {
    constructDrv = mkAutopenDerivation;

    extendDrvArgs =
      finalAttrs:
      {
        name,
        passthru ? { },
        pos ? unsafeGetAttrPos "name" args,
        ...
      }@args:
      {
        name = "${name}.tbs-certificate.der";

        autopenArgs = [
          "x509"
          "create-tbs-certificate"
          finalAttrs.certificateParams
          { output = placeholder "out"; }
        ];

        passthru = {
          inherit (finalAttrs.certificateParams) verificationKey;
        }
        // passthru;

        inherit pos;
      };
  };

  attachSignature = extendMkDerivation {
    constructDrv = mkAutopenDerivation;

    extendDrvArgs =
      finalAttrs:
      {
        name,
        signature,
        passthru ? { },
        pos ? unsafeGetAttrPos "name" args,
        ...
      }@args:
      let
        tbsCertificate = signature.message;
      in
      {
        name = "${name}.cer";

        autopenArgs = [
          "x509"
          "create-certificate"
          tbsCertificate.certificateParams
          {
            inherit signature;
            output = placeholder "out";
          }
        ];

        passthru = {
          inherit (tbsCertificate) verificationKey certificateParams;
          inherit tbsCertificate signature;
        }
        // passthru;

        inherit pos;
      };
  };

  mkSelfSignedCertificate = extendMkDerivation {
    constructDrv = attachSignature;

    # Ensure that the signing key doesn’t leak from the derivation.
    excludeDrvArgNames = [ "signingKey" ];

    extendDrvArgs =
      finalAttrs:
      {
        name,
        signingKey,
        certificateParams,
        pos ? unsafeGetAttrPos "name" args,
        meta ? { },
        ...
      }@args:
      {
        signature = sign {
          inherit signingKey;

          message = mkTbsCertificateForSelfSigning {
            inherit name;

            certificateParams = certificateParams // {
              inherit (signingKey) verificationKey;
            };

            inherit pos;

            meta = meta // {
              ${if meta ? description then "description" else null} = "${meta.description} (to be signed)";
            };
          };

          inherit pos;

          meta = meta // {
            ${if meta ? description then "description" else null} = "${meta.description} (signature)";
          };
        };

        inherit pos meta;
      };
  };
}
