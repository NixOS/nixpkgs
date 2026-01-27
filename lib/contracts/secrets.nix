{ lib }:
let
  inherit (lib) mkOption;
  inherit (lib.types) listOf submodule str;
in
{
  mkConsumerOptions =
    {
      mode ? "0400",
      owner ? "root",
      group ? "root",
      restartUnits ? [ ],
    }:
    mkOption {
      description = ''
        Consumer part of the contract for secrets.
      '';

      default = { };

      type = submodule {
        options = {
          mode = mkOption {
            description = ''
              Mode the secret file must have.
            '';
            type = str;
            default = mode;
          };

          owner = mkOption {
            description = ''
              Linux user that must own the secret file.
            '';
            type = str;
            default = owner;
          };

          group = mkOption {
            description = ''
              Linux group that must own the secret file.
            '';
            type = str;
            default = group;
          };

          restartUnits = mkOption {
            description = ''
              Systemd units to restart after the secret is updated.
            '';
            type = listOf str;
            default = restartUnits;
          };
        };
      };
    };

  mkProviderOptions =
    {
      path ? null,
    }:
    mkOption {
      description = ''
        Providers part of the contract for secrets.
      '';

      default = { };

      type = submodule {
        options = {
          path = mkOption (
            {
              type = lib.types.str;
              description = ''
                Path to the file containing the secret generated out of band.

                This path will exist after deploying to a target host,
                it is not available through the nix store.
              '';
            }
            // (
              if (path != null) then
                {
                  default = path;
                }
              else
                {
                  example = "/run/secrets/secret";
                }
            )
          );
        };
      };
    };

  behaviorTest = import ./secrets/test.nix { inherit lib; };
}
