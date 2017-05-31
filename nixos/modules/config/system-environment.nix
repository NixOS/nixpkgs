# This module defines a system-wide environment that will be
# initialised by pam_env (that is, not only in shells).
{ config, lib, utils, pkgs, ... }:

with lib;

let

  cfg = config.environment;

in

{

  options = {

    environment.sessionVariables = mkOption {
      type = utils.environmentAttrs;
      default = {};
      description = ''
        A set of environment variables used in the global environment.
        These variables will be set by PAM.
        The value of each variable can be either a string or a list of
        strings.  The latter is concatenated, interspersed with colon
        characters.
      '';
    };

  };

  config = {

    system.build.pamEnvironment = pkgs.writeText "pam-environment"
       ''
         ${concatStringsSep "\n" (mapAttrsToList (n: v: ''${n}="${utils.makeEnvironmentValue v}"'') cfg.sessionVariables)}
       '';

  };

}
