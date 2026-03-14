{ config, lib, ... }:
{
  options = {
    theOption = lib.mkOption {
      type = lib.types.optionDeclaration;
    };
    anOption = config.theOption;
  };
  config = {
    theOption = lib.mkOption {
      type = lib.types.int;
    };
    anOption = 10;
  };
}
