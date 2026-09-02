{
  lib,
  buildPackages,
  autopen,
}:

let
  inherit (lib)
    concatMapStringsSep
    escapeURL
    extendMkDerivation
    getLib
    splitString
    unsafeGetAttrPos
    ;

  inherit (autopen)
    sign
    ;

  inherit (autopen.internal)
    mkCliDerivationBuilder
    ;

  inherit (autopen.authenticode)
    attachSignature
    mkSignedAttrsForPe
    ;

  mkSystemdSbsignDerivation = mkCliDerivationBuilder {
    package = getLib buildPackages.systemd;
    exe = "${getLib buildPackages.systemd}/lib/systemd/systemd-sbsign";
    attrPrefix = "systemdSbsign";
  };

  escapeURLPath = path: concatMapStringsSep "/" escapeURL (splitString "/" path);
in
{
  mkSignedAttrsForPe = extendMkDerivation {
    constructDrv = mkSystemdSbsignDerivation;

    extendDrvArgs =
      finalAttrs:
      {
        pname,
        version,
        certificate,
        peFile,
        pos ? unsafeGetAttrPos "pname" args,
        ...
      }@args:
      {
        name = "${pname}-${version}-${baseNameOf peFile}.signed-attrs.der";

        systemdSbsignArgs = [
          "sign"
          finalAttrs.certificateArgs
          {
            prepareOfflineSigning = true;
            output = placeholder "out";
          }
          peFile
        ];

        # `systemd-sbsign(1)` expects a PEM‐encoded certificate, but
        # autopen produces DER-encoded certificates. We explicitly
        # use the default OpenSSL provider, which takes `file://`
        # URLs and accepts both encodings.
        certificateArgs = {
          certificateSource = "provider:default";
          certificate = "file://${escapeURLPath "${certificate}"}";
        };

        certificateNotBefore = certificate.certificateParams.notBefore;

        preSystemdSbsign = ''
          export SOURCE_DATE_EPOCH="$(date --date="$certificateNotBefore" +%s)"
        '';

        inherit pos;
      };
  };

  attachSignature = extendMkDerivation {
    constructDrv = mkSystemdSbsignDerivation;

    extendDrvArgs =
      finalAttrs:
      {
        pname,
        version,
        signature,
        passthru ? { },
        pos ? unsafeGetAttrPos "pname" args,
        ...
      }@args:
      let
        signedAttrs = signature.message;
      in
      {
        name = "${pname}-${version}-${baseNameOf signedAttrs.peFile}.signed";

        systemdSbsignArgs = [
          "sign"
          signedAttrs.certificateArgs
          {
            signedData = signedAttrs;
            signedDataSignature = signature;
            output = placeholder "out";
          }
          signedAttrs.peFile
        ];

        passthru = {
          inherit (signedAttrs) certificate peFile;
          inherit signedAttrs;
        }
        // passthru;

        inherit pos;
      };
  };

  mkSignedPe = extendMkDerivation {
    constructDrv = attachSignature;

    # Ensure that the signing key doesn’t leak from the derivation.
    excludeDrvArgNames = [ "signingKey" ];

    extendDrvArgs =
      finalAttrs:
      {
        pname,
        version,
        signingKey,
        certificate,
        peFile,
        pos ? unsafeGetAttrPos "pname" args,
        meta ? { },
        ...
      }@args:
      {
        signature = sign {
          inherit signingKey;

          message = mkSignedAttrsForPe {
            inherit
              pname
              version
              certificate
              peFile
              pos
              ;

            meta = meta // {
              ${if meta ? description then "description" else null} = "${meta.description} (to be signed)";
            };
          };

          inherit pos;

          meta = meta // {
            ${if meta ? description then "description" else null} = "${meta.description} (signature)";
          };
        };

        inherit pos;
      };
  };
}
