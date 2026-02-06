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
    nullOr
    str
    submodule
    ;
  inherit (pkgs) writeText;
in
{
  options.testing.hardcoded-secret = mkOption {
    default = { };
    description = ''
      Hardcoded secrets. These should only be used in tests.
    '';
    example = lib.literalExpression ''
      {
        mySecret = {
          input = {
            user = "me";
            mode = "0400";
            restartUnits = [ "myservice.service" ];
          };
          settings.content = "My Secret";
        };
      }
    '';
    type = attrsOf (
      submodule (
        { name, ... }:
        lib.contracts.secrets.mkProvider {
          providerOptions = mkOption {
            description = ''
              Settings specific to the hardcoded secrets module.

              Define either `content` or `source`.
            '';

            type = submodule {
              options = {
                content = mkOption {
                  type = nullOr str;
                  description = ''
                    Content of the secret as a string.

                    This will be stored in the nix store and should only be used for testing or maybe in dev.
                  '';
                  default = null;
                };

                source = mkOption {
                  type = nullOr str;
                  description = ''
                    Source of the content of the secret as a path in the nix store.
                  '';
                  default = null;
                };
              };
            };
          };

          outputDefaults = {
            path = "/run/hardcodedsecrets/hardcodedsecret_${name}";
          };
        }
      )
    );
  };

  config = {
    system.activationScripts = mapAttrs' (
      n: cfg':
      let
        source =
          if cfg'.providerOptions.source != null then
            cfg'.providerOptions.source
          else
            writeText "hardcodedsecret_${n}_content" cfg'.providerOptions.content;
      in
      nameValuePair "hardcodedsecret_${n}" ''
        mkdir -p "$(dirname "${cfg'.output.path}")"
        touch "${cfg'.output.path}"
        chmod ${cfg'.input.mode} "${cfg'.output.path}"
        chown ${cfg'.input.owner}:${cfg'.input.group} "${cfg'.output.path}"
        cp ${source} "${cfg'.output.path}"
      ''
    ) cfg;
  };
}
