{
  name,
  lib,
  ...
}:
let
  inherit (lib) mkOption types literalMD;
  inherit (types) nullOr str path;
in
{
  options = {

    name = mkOption {
      type = str;
      default = name;
      defaultText = literalMD "the attribute name";
      description = "name of the service";
    };

    secretFile = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        Optional path to file containing secret for authentication.
      '';
    };
  };
}
