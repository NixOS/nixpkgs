{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.testing.hardcoded-secret;

  inherit (lib) mapAttrs' mkOption nameValuePair;
  inherit (lib.types)
    attrsOf
    str
    submodule
    ;
  inherit (pkgs) writeText;
in
{
  options.testing.hardcoded-secret = mkOption {
    default = { };
    description = ''
      Hardcoded file secrets. These should only be used in tests.

      They aim to replace the usage of pkgs.writeText in NixOS VM tests
      as those make the file world readable
      while this module set runtime permissions on the file.
      This makes the tests more accurate, ensuring the permissions
      set by the contract consumer are correct.
    '';
    example = lib.literalExpression ''
      {
        mySecret = {
          request = {
            user = "me";
            mode = "0400";
          };
          content = "My Secret";
        };
      }
    '';
    type = attrsOf (
      submodule (
        { name, ... }:
        {
          options = {
            request = mkOption {
              description = "Request of the file secrets contract: the consumer states the file permissions it needs.";
              type = lib.types.submodule {
                options = {
                  mode = mkOption {
                    description = ''
                      Mode the secret file must have.
                    '';
                    type = str;
                    default = "0400";
                  };

                  owner = mkOption {
                    description = ''
                      Linux user that must own the secret file.
                    '';
                    type = str;
                    default = "root";
                  };

                  group = mkOption {
                    description = ''
                      Linux group that must own the secret file.
                    '';
                    type = str;
                    default = "root";
                  };
                };
              };
            };

            response = mkOption {
              description = "Response of the file secrets contract: the provider states where the file is.";
              default = { };
              type = lib.types.submodule {
                options = {
                  path = mkOption {
                    type = str;
                    description = ''
                      Path to the file containing the secret generated out of band.

                      This path will exist after deploying to a target host,
                      it is not available through the nix store.
                    '';
                    default = "/run/hardcodedsecrets/${name}";
                  };
                };
              };
            };

            content = mkOption {
              type = str;
              description = ''
                Content of the secret as a string.

                This will be stored in the nix store and should only be used for testing or maybe in dev.
              '';
            };
          };
        }
      )
    );
  };

  config = {
    system.activationScripts = mapAttrs' (
      n: cfg':
      let
        source = writeText "hardcodedsecret_${n}_content" cfg'.content;

        inherit (cfg') request response;
      in
      nameValuePair "hardcodedsecret_${n}" ''
        mkdir -p "$(dirname "${response.path}")"
        touch "${response.path}"
        chmod ${request.mode} "${response.path}"
        chown ${request.owner}:${request.group} "${response.path}"
        cp ${source} "${response.path}"
      ''
    ) cfg;
  };
}
