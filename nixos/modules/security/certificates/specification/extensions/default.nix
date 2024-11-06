{ lib, ... }:
let
  inherit (lib)
    mkOption
    types;
  extensionOptions.options = {
    critical = mkOption {
      type = types.bool;
      description = ''
        Mark extension as critical. Critical extensions MUST be handled by
        clients attempting to validate the certificate.

        ::{.note}
        It is generally safe to make standard extensions as critical but may
        cause issues for older or non-standard X.509 implementations.
        :::
      '';
      default = true;
    };
    _value = mkOption {
      type = types.str;
      description = ''
        The value to be assigned to the extensions corresponding
        attribute within the final CSR generator OpenSSL config.
      '';
      internal = true;
    };
    _extraSections = mkOption {
      type = with types; attrsOf (attrsOf str);
      description = ''
        Extra sections to be created within the OpenSSL config file. Uses a
        INI-style atrribute layout.
      '';
    };
  };
in
{
  options.extensions = mkOption {
    type = types.submodule {
      freeformType = with types; attrsOf
        (oneOf [
          str
          (listOf str)
        ]);
      imports = [
        {
          config._module.args = {
            inherit extensionOptions;
          };
        }
        ./subjectAltName.nix
      ];
    };
    description = ''
      Additional X.509 extension requests to add to the CSR. See OpenSSL
      x509v3_config for allowed values. Format is `extensionName = value;`.
      multi-values can be given in a list and will be joined automatically.
    '';
    default = {
      basicConstraints = "CA:FALSE";
    };
    example = ''
      keyUsage = [
        "critical"
        "digitalSignature"
        "keyCertSign"
      ];
    '';
  };

}
