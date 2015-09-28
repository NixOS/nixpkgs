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
      type = types.attrsOf (types.loeOf types.str);
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
