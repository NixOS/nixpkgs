{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    types
    isList
    mapAttrs
    concatStringsSep
    ;
in
{
  options = {
    environment.variables = mkOption {
      default = { };
      example = { EDITOR = "nvim"; VISUAL = "nvim"; };
      description = ''
        A set of environment variables used in the global environment.
        These variables will be set on shell initialisation (e.g. in /etc/profile).
        The value of each variable can be either a string or a list of
        strings.  The latter is concatenated, interspersed with colon
        characters.
      '';
      type = with types; attrsOf (either str (listOf str));
      apply = mapAttrs (n: v: if isList v then concatStringsSep ":" v else v);
    };
  };
}
