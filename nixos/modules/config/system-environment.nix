# This module defines a system-wide environment that will be
# initialised by pam_env (that is, not only in shells).
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.environment;

in

{

  options = {

    environment.sessionVariables = mkOption {
      default = {};
      description = ''
        A set of environment variables used in the global environment.
        These variables will be set by PAM.
        The value of each variable can be either a string or a list of
        strings.  The latter is concatenated, interspersed with colon
        characters.
      '';
      type = types.attrsOf (mkOptionType {
        name = "a string or a list of strings";
        merge = loc: defs:
          let
            defs' = filterOverrides defs;
            res = (head defs').value;
          in
          if isList res then concatLists (getValues defs')
          else if lessThan 1 (length defs') then
            throw "The option `${showOption loc}' is defined multiple times, in ${showFiles (getFiles defs)}."
          else if !isString res then
            throw "The option `${showOption loc}' does not have a string value, in ${showFiles (getFiles defs)}."
          else res;
      });
      apply = mapAttrs (n: v: if isList v then concatStringsSep ":" v else v);
    };

  };

  config = {

    system.build.pamEnvironment = pkgs.writeText "pam-environment"
       ''
         ${concatStringsSep "\n" (
           (mapAttrsToList (n: v: ''${n}="${concatStringsSep ":" v}"'')
             (zipAttrsWith (const concatLists) ([ (mapAttrs (n: v: [ v ]) cfg.sessionVariables) ]))))}
       '';

  };

}
