{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str path;
in
{
  contracts.secret = {
    meta = {
      maintainers = [ lib.maintainers.ibizaman ];
      description = ''
        Contract for secrets handling where a consumer requests a secret
        and a provider provides it at runtime at a given file path.
      '';
    };

    input = {
      options.mode = mkOption {
        description = ''
          Mode of the secret file.
        '';
        type = str;
      };

      options.owner = mkOption {
        description = ''
          Linux user owning the secret file.
        '';
        type = str;
      };

      options.group = mkOption {
        description = ''
          Linux group owning the secret file.
        '';
        type = str;
      };
    };

    output = {
      options.path = mkOption {
        type = path;
        description = ''
          Path to the file containing the secret generated out of band.

          This path will exist after deploying to a target host,
          it is not available through the nix store.
        '';
      };
    };
  };
}
