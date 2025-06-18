{ lib, config, ... }:
let
  t = lib.types;
in
{
  options = {
    virtualisation.diskSizeAutoSupported = lib.mkOption {
      type = t.bool;
      default = true;
      description = ''
        Whether the current image builder or vm runner supports `virtualisation.diskSize = "auto".`
      '';
      internal = true;
    };

    virtualisation.diskSize = lib.mkOption {
      type = t.either (t.enum [ "auto" ]) t.ints.positive;
      default = if config.virtualisation.diskSizeAutoSupported then "auto" else 1024;
      defaultText = lib.literalExpression "if virtualisation.diskSizeAutoSupported then \"auto\" else 1024";
      description = ''
        The disk size in megabytes of the virtual machine.
      '';
    };
  };

  config =
    let
      inherit (config.virtualisation) diskSize diskSizeAutoSupported;
    in
    {
      assertions = [
        {
          assertion = diskSize != "auto" || diskSizeAutoSupported;
          message = "Setting virtualisation.diskSize to `auto` is not supported by the current image build or vm runner; use an explicit size.";
        }
      ];
    };
}
