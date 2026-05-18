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
    mkOption
    ;
  inherit (lib.types)
    str
    submodule
    ;
  inherit (pkgs) writeText;
  contract = "fileSecrets";
  providerName = "hardcoded-secret";
  inherit (lib.contract.forModule config) fileSecrets;
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
          default = config.contracts.${contract}.providerRequests.${providerName};
          defaultText = lib.literalExpression "config.contracts.${contract}.providerRequests.${providerName}";
          type = fileSecrets.mkProviderType {
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
    contracts.${contract}.providers.hardcoded-secret.module = options.testing.hardcoded-secret;

    systemd.services = lib.mkMerge [
      # Oneshot services that materialize each secret after users and sysusers are ready.
      (lib.concatMapNestedAttrs'
        (options.testing.hardcoded-secret.type.getSubOptions [ ]).${contract}.type
        (
          path: cfg':
          let
            name = lib.concatStringsSep "_" path;
            source = writeText "hardcodedsecret_${name}_content" cfg'.content;
            inherit (cfg') request result;
          in
          {
            "hardcoded-secret-${name}" = {
              description = "Materialize hardcoded test secret ${name}";
              wantedBy = [ "multi-user.target" ];
              before = [ "multi-user.target" ];
              after = [
                "systemd-sysusers.service"
                "nixos-activation.service"
              ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
              script = ''
                install -D -m ${request.mode} -o ${request.owner} -g ${request.group} \
                  ${source} "${result.path}"
              '';
            };
          }
        )
        cfg.${contract}
      )

      # Make each top-level consumer service wait for all its secret services.
      # Assumes secrets are keyed as `<appName>.<secretName>` matching `<appName>.service`.
      (lib.mapAttrs (
        appName: appSecrets:
        let
          secretSvcs = lib.mapAttrsToList (
            secretName: _: "hardcoded-secret-${appName}_${secretName}.service"
          ) appSecrets;
        in
        {
          after = secretSvcs;
          requires = secretSvcs;
        }
      ) cfg.${contract})
    ];
  };
}
