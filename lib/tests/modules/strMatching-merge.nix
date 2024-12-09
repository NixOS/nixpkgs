{ lib, ... }:
{
  imports = [
    {
      options.sm = lib.mkOption {
        type = lib.types.strMatching "\(.*\)";
      };
    }
    {
      options.sm = lib.mkOption {
        type = lib.types.strMatching "\(.*\)";
      };
    }
  ];
}
