{ lib, ... }:
{
  options.hardware.facter.changes = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
    internal = true;
    description = ''
      Values contributed by facter modules.
      Does not reflect the final merged value, only facter's contribution.
    '';
  };
}
