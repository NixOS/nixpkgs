{ config, lib, ... }:

with lib;

let sourceInfo = config.system.nixos.configuration.sourceInfo;

in
{
  options = {

    system.nixos.configuration.sourceInfo = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      example = lib.literalExpression ''
      {
        inputs.nixpkgs.url = ...;
        outputs = { self, nixpkgs }: {
          nixosConfigurations = {
            host = nixpkgs.lib.nixosSystem {
              modules = [
                { system.nixos.configuration.sourceInfo = self.sourceInfo; }
              ] ++ ...;
            };
          };
        };
      }
      '';
      description = lib.mdDoc ''
        The source information of a flake-based NixOS configuration.
        If set, the attribute `configurationRevision` will appear
        properly in the output of `nixos-version --json`.

        **Caution:** Setting this option may result in unnecessary
        re-deployments if the flake repository changes but the
        specific system configuration does not change.
      '';
    };
  };

  config = {
    system.configurationRevision = mkIf (sourceInfo ? rev) sourceInfo.rev;
  };
}
