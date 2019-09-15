{ config, lib, ... }:

with lib;

let
  validCertUsages = [
    "signing"
    "digital signature"
    "key encipherment"
    "server auth"
    "client auth"
    "cert sign"
    "crl sign"
  ];

  enabledProfiles = filterAttrs (_: profile: profile.enable) config.signing.profiles;
  enabledAuthKeys = filterAttrs (_: profile: profile.enable) config.authKeys;

  validAuthKeys = mapAttrsToList (_: key: key.name) enabledAuthKeys;

  profileOptions = { config, name, ... }: {
    options = {
      expiry = mkOption {
        description = "Certificate expiration time in hours.";
        type = types.nullOr types.str;
        default = null;
        example = "8760h";
      };

      usages = mkOption {
        description = "Cert usages";
        type = types.nullOr (types.listOf (types.enum validCertUsages));
        default = null;
        example = "server";
      };

      caConstraint = {
        isCA = mkOption {
          description = "Whether certificate is CA.";
          type = types.nullOr types.bool;
          default = null;
        };

        maxPathLength = mkOption {
          description = "Certificate max path length";
          type = types.nullOr types.int;
          default = null;
        };

        maxPathLenZero = mkOption {
          description = "Certificate max path zero length";
          type = types.nullOr types.bool;
          default = null;
        };
      };

      nameWhitelist = mkOption {
        description = "Regular expression for premitted SANs.";
        type = types.nullOr types.str;
        default = null;
      };

      authKey = mkOption {
        description = "Name of the cfssl authentication key to use.";
        type = types.nullOr (types.enum validAuthKeys);
        default = null;
      };
    };
  };

  authKeyOptions = { config, name, ... }: {
    options = {
      name = mkOption {
        description = "Name of the auth key";
        type = types.str;
        default = name;
      };

      enable = mkOption {
        description = "Whether to enable auth key";
        type = types.bool;
        default = true;
      };

      type = mkOption {
        description = "Auth key type";
        type = types.enum ["standard"];
        default = "standard";
      };

      key = mkOption {
        description = "Auth key value";
        type = types.str;
      };
    };
  };

  filterEmpty = filterAttrsRecursive (_: v: v != null && v != {} && v != []);

  toSigningProfile = profile: filterEmpty {
    usages = profile.usages;
    expiry = profile.expiry;
    auth_key = profile.authKey;
    ca_constraint = {
      is_ca = profile.caConstraint.isCA;
      max_path_len = profile.caConstraint.maxPathLength;
      max_path_len_zero = profile.caConstraint.maxPathLenZero;
    };
    name_whitelist = profile.nameWhitelist;
  };

  toAuthKey = key: filterEmpty {
    inherit (key) type key;
  };

in {
  options = {
    signing = {
      profiles = mkOption {
        description = "Attribute set of cert signing profiles.";
        type = types.attrsOf (types.submodule ({ name, ...}: {
          imports = [ profileOptions ];

          options = {
            enable = mkOption {
              description = "Whether to enable profile.";
              type = types.bool;
              default = true;
            };

            name = mkOption {
              description = "Name of the profile.";
              type = types.str;
              default = name;
            };
          };
        }));
        default = {};
      };

      default = mkOption {
        description = "Default signing options.";
        type = types.submodule profileOptions;
        default = {};
      };
    };

    authKeys = mkOption {
      description = "Attribute set of auth keys.";
      type = types.attrsOf (types.submodule authKeyOptions);
      default = {};
    };

    generated = mkOption {
      description = "Generated CFSSL configuration";
      type = types.attrs;
      internal = true;
    };

    file = mkOption {
      description = "Generated config file";
      type = types.package;
      internal = true;
    };
  };

  config = {
    generated = filterEmpty {
      signing = {
        default = toSigningProfile config.signing.default;
        profiles = mapAttrs' (_: p:
          nameValuePair p.name (toSigningProfile p)
        ) enabledProfiles;
      };
      auth_keys = mapAttrs' (_: k:
        nameValuePair k.name (toAuthKey k)
      ) enabledAuthKeys;
    };

    file = builtins.toFile "cfssl-config.json" (builtins.toJSON config.generated);
  };
}
