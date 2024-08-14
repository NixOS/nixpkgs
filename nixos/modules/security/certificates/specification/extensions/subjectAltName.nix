{ lib, extensionOptions, config, ... }:
let
  inherit (lib)
    concatStringsSep
    filterAttrs
    length
    mapAttrs
    mkOption
    types;
  mkAltNameOption = description: mkOption {
    inherit description;
    type = with types; listOf str;
    default = [ ];
  };
in
{
  options.subjectAltName = mkOption {
    type = types.submodule {
      imports = [ extensionOptions ];
      options = {
        email = mkAltNameOption ''email addresses'';
        URI = mkAltNameOption ''Uniform Resource Indicator'';
        DNS = mkAltNameOption ''DNS domain name'';
        RID = mkAltNameOption ''registered ID'';
        IP = mkAltNameOption ''IP address'';
        # TODO: fancy names needing special handling
        # dirName = mkAltName ''distinguished name'';
        # otherName = mkAltName ''other identifiers'';
      };
    };
    description = ''
      One or more alternative names to attach to the certificate.

      See https://docs.openssl.org/master/man5/x509v3_config/#subject-alternative-name
      for a description of fields.
    '';
  };

  config.subjectAltName =
    let
      names = filterAttrs
        (_: list: length list > 0)
        { inherit (config.subjectAltName) email URI DNS RID IP; };
    in
    {
      _value = "@subjectAltName";
      _extraSections = {
        subjectAltName = mapAttrs
          (_: list: concatStringsSep "," list)
          names;
      };
    };
}
