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
  options.testing.hardcoded-secret = {
    directory = mkOption {
      type = str;
      default = "/run/hardcodedsecrets";
      description = ''
        Directory in which the provider writes the secret files.
        Each secret file has the name of its entry in
        [](#opt-testing.hardcoded-secret.fileSecrets).
      '';
    };

    fileSecrets = mkOption {
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
              owner = "me";
              group = "me";
              mode = "0400";
            };
            providerOptions.content = "My Secret";
          };
        }
      '';
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            imports = [ ../contracts/file-secrets.nix ];

            options = {
              request = mkOption {
                type = submodule {
                  options = {
                    owner = mkOption { default = "root"; };
                    group = mkOption { default = "root"; };
                  };
                };
              };

              response = mkOption {
                default = { };
                type = submodule {
                  options.path = mkOption {
                    default = "${cfg.directory}/${name}";
                    defaultText = lib.literalExpression ''"''${config.testing.hardcoded-secret.directory}/<name>"'';
                  };
                };
              };

              providerOptions = {
                content = mkOption {
                  type = str;
                  description = ''
                    Content of the secret as a string.

                    This will be stored in the nix store and should only be used for testing or maybe in dev.
                  '';
                };
              };
            };
          }
        )
      );
    };
  };

  config = {
    system.activationScripts = mapAttrs' (
      n: cfg':
      let
        source = writeText "hardcodedsecret_${n}_content" cfg'.providerOptions.content;

        inherit (cfg') request response;
      in
      nameValuePair "hardcodedsecret_${n}" ''
        mkdir -p "$(dirname "${response.path}")"
        touch "${response.path}"
        chmod ${request.mode} "${response.path}"
        chown ${request.owner}:${request.group} "${response.path}"
        cp ${source} "${response.path}"
      ''
    ) cfg.fileSecrets;
  };
}
