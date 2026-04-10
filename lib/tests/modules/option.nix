{
  config,
  lib,
  options,
  ...
}:
{
  options = {
    theOption = lib.mkOption {
      type = lib.types.optionDeclaration;
    };
    anOption = config.theOption;
    aBadOptionDef = lib.mkOption {
      type = lib.types.optionDeclaration;
      description = ''
        This option is perfectly fine, but will have a bad definition.
      '';
    };
  };
  config = {
    theOption = lib.mkOption {
      type = lib.types.int;
    };
    anOption = 10;
    aBadOptionDef = options.theOption; # Not a declaration
  };
}
