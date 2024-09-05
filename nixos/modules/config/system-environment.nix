# This module defines a system-wide environment that will be
# initialised by pam_env (that is, not only in shells).
{ config, lib, options, pkgs, ... }:
let

  cfg = config.environment;

in

{

  options = {

    environment.sessionVariables = lib.mkOption {
      default = {};
      description = ''
        A set of environment variables used in the global environment.
        These variables will be set by PAM early in the login process.

        The value of each session variable can be either a string or a
        list of strings. The latter is concatenated, interspersed with
        colon characters.

        Note, due to limitations in the PAM format values may not
        contain the `"` character.

        Also, these variables are merged into
        [](#opt-environment.variables) and it is
        therefore not possible to use PAM style variables such as
        `@{HOME}`.
      '';
      inherit (options.environment.variables) type apply;
    };

    environment.profileRelativeSessionVariables = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      example = { PATH = [ "/bin" ]; MANPATH = [ "/man" "/share/man" ]; };
      description = ''
        Attribute set of environment variable used in the global
        environment. These variables will be set by PAM early in the
        login process.

        Variable substitution is available as described in
        {manpage}`pam_env.conf(5)`.

        Each attribute maps to a list of relative paths. Each relative
        path is appended to the each profile of
        {option}`environment.profiles` to form the content of
        the corresponding environment variable.

        Also, these variables are merged into
        [](#opt-environment.profileRelativeEnvVars) and it is
        therefore not possible to use PAM style variables such as
        `@{HOME}`.
      '';
    };

  };

  config = {
    environment.etc."pam/environment".text = let
      suffixedVariables =
        lib.flip lib.mapAttrs cfg.profileRelativeSessionVariables (envVar: suffixes:
          lib.flip lib.concatMap cfg.profiles (profile:
            map (suffix: "${profile}${suffix}") suffixes
          )
        );

      # We're trying to use the same syntax for PAM variables and env variables.
      # That means we need to map the env variables that people might use to their
      # equivalent PAM variable.
      replaceEnvVars = lib.replaceStrings ["$HOME" "$USER"] ["@{HOME}" "@{PAM_USER}"];

      pamVariable = n: v:
        ''${n}   DEFAULT="${lib.concatStringsSep ":" (map replaceEnvVars (lib.toList v))}"'';

      pamVariables =
        lib.concatStringsSep "\n"
        (lib.mapAttrsToList pamVariable
        (lib.zipAttrsWith (n: lib.concatLists)
          [
            # Make sure security wrappers are prioritized without polluting
            # shell environments with an extra entry. Sessions which depend on
            # pam for its environment will otherwise have eg. broken sudo. In
            # particular Gnome Shell sometimes fails to source a proper
            # environment from a shell.
            { PATH = [ config.security.wrapperDir ]; }

            (lib.mapAttrs (n: lib.toList) cfg.sessionVariables)
            suffixedVariables
          ]));
    in ''
      ${pamVariables}
    '';
  };

}
