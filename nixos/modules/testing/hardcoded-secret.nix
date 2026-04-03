{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.testing.hardcoded-secret;

  inherit (lib)
    contracts
    mkOption
    ;
  inherit (lib.types)
    str
    submodule
    ;
  inherit (pkgs) writeText;
  contract = "fileSecrets";
  inherit (contracts.${contract}) mkProviderType;
in
{
  options.testing.hardcoded-secret = mkOption {
    description = ''
      Hardcoded file secrets. These should only be used in tests.

      They aim to replace the usage of pkgs.writeText in NixOS VM tests
      as those make the file world readable
      while this module set runtime permissions on the file.
      This makes the tests more accurate, ensuring the permissions
      set by the contract consumer are correct.
    '';
    type = submodule (hardcoded-secret: {
      options = {
        directory = mkOption {
          description = "The directory to store the secrets at.";
          type = str;
          default = "/run/hardcodedsecrets";
        };
        ${contract} = mkOption {
          description = ''
            Instances of the fileSecrets contract, including secret content and contract request/result.
          '';
          example = lib.literalExpression ''
            {
              my.secret = {
                request = {
                  owner = "me";
                  mode = "0400";
                };
                content = "My Secret";
              };
            }
          '';
          default = config.contracts.${contract}.requests;
          defaultText = lib.literalExpression "config.contracts.${contract}.requests";
          type = mkProviderType {
            overrides.request = {
              owner.default = "root";
              group.default = "root";
            };
            providerOptions.content = mkOption {
              type = str;
              description = ''
                Content of the secret as a string.

                This will be stored in the nix store and should only be used for testing or maybe in dev.
              '';
            };
            fulfill' =
              { name, ... }:
              {
                path = "${hardcoded-secret.config.directory}/${name}";
              };
          };
        };
      };
    });
  };

  config = {
    contracts.${contract}.providers.hardcoded-secret = config.testing.hardcoded-secret.${contract};

    system.activationScripts =
      lib.concatMapNestedAttrs' (options.testing.hardcoded-secret.type.getSubOptions [ ]).${contract}.type
        (
          path: cfg':
          let
            name = lib.concatStringsSep "_" path;
            source = writeText "hardcodedsecret_${name}_content" cfg'.content;
            inherit (cfg') request result;
          in
          {
            ${"hardcodedsecret_${name}"} = ''
              mkdir -p "$(dirname "${result.path}")"
              touch "${result.path}"
              chmod ${request.mode} "${result.path}"
              chown ${request.owner}:${request.group} "${result.path}"
              cp ${source} "${result.path}"
            '';
          }
        )
        cfg.${contract};
  };
}
