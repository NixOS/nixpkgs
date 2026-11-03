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

        For each entry, a service writes `providerOptions.content` to `response.path`,
        with the `mode`, `owner` and `group` from `request`.
        The service runs after `systemd-sysusers` or `userborn`, and before `sysinit.target`,
        thus the file exists before the services that use it start.
        The content is also in the Nix store, where each user can read it.
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
            imports = [ lib.contracts.fileSecrets.interface ];

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

              providerOptions = mkOption {
                description = "Options of this provider that are not part of the file secrets contract.";
                default = { };
                type = submodule {
                  options.content = mkOption {
                    type = str;
                    description = ''
                      Content of the secret as a string.

                      This will be stored in the nix store and should only be used for testing or maybe in dev.
                    '';
                  };
                };
              };
            };
          }
        )
      );
    };
  };

  config = {
    # Write each secret in a service and not in an activation script.
    # An activation script can run before the owner of the secret exists:
    # activation scripts without dependencies run in alphabetical order,
    # and `systemd-sysusers` and `userborn` create users after activation.
    # The services run before `sysinit.target`, thus before all services
    # that have default dependencies, such as the consumers of the secrets.
    systemd.services = mapAttrs' (
      n: cfg':
      let
        source = writeText "hardcodedsecret_${n}_content" cfg'.providerOptions.content;

        inherit (cfg') request response;
      in
      nameValuePair "hardcodedsecret_${n}" {
        description = "Hardcoded secret ${n}";
        wantedBy = [ "sysinit.target" ];
        after = [
          "local-fs.target"
          "systemd-sysusers.service"
          "userborn.service"
        ];
        before = [
          "sysinit.target"
          "shutdown.target"
        ];
        conflicts = [ "shutdown.target" ];
        unitConfig.DefaultDependencies = false;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          install -D -m ${request.mode} -o ${request.owner} -g ${request.group} \
            ${source} "${response.path}"
        '';
      }
    ) cfg.fileSecrets;
  };
}
