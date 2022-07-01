{ config, lib, ... }:

with lib;

let sourceInfo = config.system.nixos.configuration.sourceInfo;

in
{
  options = {

    system.nixos.configuration.sourceInfo = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      example = "self.sourceInfo";
      description = ''
        The source information of a flake-based NixOS configuration.
        If set, the attribute <literal>configurationRevision</literal>
        will appear properly in the output of
        <literal>nixos-version --json</literal>.

        Caution: Setting this option may result in unnecessary
        re-deployments if the flake repository changes but the
        specific system configuration does not change.
      '';
    };
  };

  config = {
    system.configurationRevision = mkIf (sourceInfo ? rev) sourceInfo.rev;
  };
}
