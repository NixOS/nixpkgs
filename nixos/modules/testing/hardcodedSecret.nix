{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.testing.hardcodedSecret;

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
  options.testing.hardcodedSecret = mkOption {
    default = { };
    description = ''
      Hardcoded secrets. These should only be used in tests.
    '';

    example = lib.literalExpression ''
      {
        mySecret = {
          secret.input = {
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
        mod@{ name, options, ... }:
        {
          options = {
            mode = mkOption {
              description = ''
                Mode of the secret file.
              '';
              type = str;
              default = "0400";
            };

            owner = mkOption {
              description = ''
                Linux user owning the secret file.
              '';
              type = str;
            };

            group = mkOption {
              description = ''
                Linux group owning the secret file.
              '';
              type = str;
              default = options.user.default;
              defaultText = "user";
            };

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

            path = mkOption {
              type = str;
              description = ''
                Path where the secret should be located.
              '';
              default = "/run/hardcodedSecrets/hardcodedSecret_${name}";
            };

            secret = mkOption {
              type = config.contracts.secret.provider;
            };
          };

          config = {
            inherit (mod.config.secret.input) mode owner group;
            secret.output.path = mod.config.path;
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
          if cfg'.source != null then cfg'.source else writeText "hardcodedSecret_${n}_content" cfg'.content;
      in
      nameValuePair "hardcodedSecret_${n}" ''
        (
          set -e
          mkdir -p "$(dirname "${cfg'.path}")"
          touch "${cfg'.path}"
          chmod ${cfg'.mode} "${cfg'.path}"
          chown ${cfg'.owner}:${cfg'.group} "${cfg'.path}"
          cp ${source} "${cfg'.path}"
        ) || echo "Failed to create hardcoded secret at ${cfg'.path}"
      ''
    ) cfg;
  };

  # Without `meta.buildDocsInSandbox = false;`, I get:
  #
  #     >        error: attribute 'contracts' missing
  #     >        at /nix/store/2gd9yzcfpqqp00vskxlqq4ds48mpgdzv-nixos/modules/testing/hardcodedSecret.nix:81:18:
  #     >            80|         secret = mkOption {
  #     >            81|           type = config.contracts.secret.provider;
  #     >              |                  ^
  #     >            82|         };
  #     > Cacheable portion of option doc build failed.
  #     > Usually this means that an option attribute that ends up in documentation (eg `default` or `description`) depends on the restricted module arguments `config` or `pkgs`.
  #     >
  #     > Rebuild your configuration with `--show-trace` to find the offending location. Remove the references to restricted arguments (eg by escaping their antiquotations or adding a `defaultText`) or disable the sandboxed build for the failing module by setting `meta.buildDocsInSandbox = false`.
  #
  # With the line, I don't get the warning but still get the missing 'contracts' attribute error.
  meta.buildDocsInSandbox = false;
}
