# Test:
#   ./meta-maintainers/test.nix
{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  # The resulting value of this type shows where all values were defined
  sourceList = types.listOf types.raw // {
    merge = loc: defs: lib.listToAttrs (lib.map ({ file, value }: lib.nameValuePair file value) defs);
  };
in
{
  _class = null; # not specific to NixOS
  options = {
    meta = {
      maintainers = mkOption {
        type =
          let
            allMaintainers = lib.attrValues lib.maintainers;
          in
          lib.types.addCheck sourceList (lib.all (v: lib.elem v allMaintainers))
          // {
            description = "list of lib.maintainers";
          };
        default = [ ];
        example = lib.literalExpression "[ lib.maintainers.alice lib.maintainers.bob ]";
        description = ''
          List of maintainers of each module.
          This option should be defined at most once per module.

          The option value is not a list of maintainers, but an attribute set that maps module file names to lists of maintainers.
        '';
      };
      teams = mkOption {
        type =
          let
            allTeams = lib.attrValues lib.teams;
          in
          lib.types.addCheck sourceList (lib.all (v: lib.elem v allTeams))
          // {
            description = "list of lib.teams";
          };
        default = [ ];
        example = lib.literalExpression "[ lib.teams.acme lib.teams.haskell ]";
        description = ''
          List of team maintainers of each module.
          This option should be defined at most once per module.
        '';
      };
    };
  };

  # This module deliberately does not define `meta.maintainers` for itself.
  # It is imported by every module system that offers the option - NixOS
  # (`nixos/modules/misc/meta.nix`) and modular services
  # (`lib/services/service.nix`) - so a definition here would attribute this
  # file's maintainers to every module and every service that imports it.
  # Ownership of this file is recorded in `ci/OWNERS` instead.
}
