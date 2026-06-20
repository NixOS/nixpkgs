{ lib, ... }:
{

  options.value = lib.mkOption {
    type = lib.types.anything;
  };

  config = lib.mkMerge [
    {
      value = [ "a value" ];
    }
    {
      value = [ "another value" ];
    }
  ];

}
