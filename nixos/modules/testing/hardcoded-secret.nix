{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.testing.hardcoded-secret;

  inherit (lib)
    contracts
    mapAttrs'
    mkOption
    nameValuePair
    ;
  inherit (lib.types)
    attrsOf
    str
    submodule
    ;
  inherit (pkgs) writeText;
  inherit (contracts) fileSecrets;
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
          input = {
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
            input = mkOption {
              description = "Input of the contract for file secrets.";
              type = fileSecrets.input {
                owner.default = "root";
                group.default = "root";
              };
            };
            output = mkOption {
              description = "Output of the contract for file secrets.";
              default = { };
              type = fileSecrets.output {
                path.default = "/run/hardcodedsecrets/${name}";
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

        inherit (cfg') input output;
      in
      nameValuePair "hardcodedsecret_${n}" ''
        mkdir -p "$(dirname "${output.path}")"
        touch "${output.path}"
        chmod ${input.mode} "${output.path}"
        chown ${input.owner}:${input.group} "${output.path}"
        cp ${source} "${output.path}"
      ''
    ) cfg;
  };
}
