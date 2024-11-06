{ config, lib, lib-cert, name, pkgs, ... }:
let
  inherit (lib)
    attrNames
    head
    mkOption
    types;
in
{
  options = {
    privateKey = mkOption {
      type = types.attrTag {
        rsa = mkOption {
          type = types.submodule {
            options.size = mkOption {
              type = types.ints.positive;
              description = ''
                RSA key size in bits
              '';
              default = 2048;
            };
          };
          description = "RSA private key";
        };
        ecdsa = mkOption {
          type = types.submodule {
            options.curve = mkOption {
              type = types.str;
              description = ''
                Named elliptic curve to use for key generation.
                See `openssl ecparam -list_curves`
              '';
              default = "prime256v1";
            };
          };
          description = "Elliptic Curve DSA private key";
        };
      };
      description = ''
        Private key generation options.
        :::{.note}
        The key will be generated at runtime and never exist within the store
        :::
      '';
      default = {
        rsa = {
          size = 2048;
        };
      };
    };
  };
  config.output.scripts.mkKey =
    let
      inherit (config) privateKey;
      openssl = lib-cert.openssl.toShell;
      scriptName = "certificate-${name}-mkKey";
      text =
        # RSA keys
        if (privateKey ? rsa) then
          openssl "genpkey"
            {
              outform = "PEM";
              algorithm = "RSA";
              pkeyopt = "rsa_keygen_bits:${toString privateKey.rsa.size}";
            }
        # Elliptic-Curve DSA keys
        else if (privateKey ? ecdsa) then
          openssl "ecparam"
            {
              outform = "PEM";
              name = privateKey.ecdsa.curve;
              genkey = true;
            }
        else
          abort "Unknown key type: ${head (attrNames privateKey)}";
      app = pkgs.writeShellApplication {
        inherit text;
        name = scriptName;
        runtimeInputs = [ pkgs.openssl ];
      };
    in
    "${app}/bin/${scriptName}";
}
