{ lib, ... }:
{
  options.shy = lib.mkOption {
    writeOnly = true;
    type = lib.types.string;
  };

  options.notRecommended = lib.mkOption {
    writeOnly = true;
    writeOnlyErrorMessage = "Read from the recommended option instead.";
    type = lib.types.string;
  };
}
