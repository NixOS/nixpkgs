{
  lib,
  config,
  pkgs,
  ...
}:
let
  preSwitchCheckScript = lib.concatLines (
    lib.mapAttrsToList (name: text: ''
      # pre-switch check ${name}
      #
      # Run with errexit in a subshell that is not part of an `if`/`||`
      # condition, so that `set -e` is actually honoured inside the
      # check body.
      set +e
      (
        set -e
        ${text}
      ) >&2
      _rc=$?
      set -e
      if [ "$_rc" -ne 0 ]; then
        echo "Pre-switch check '${name}' failed" >&2
        exit 1
      fi
    '') config.system.preSwitchChecks
  );
in
{
  options.system.preSwitchChecksScript = lib.mkOption {
    type = lib.types.pathInStore;
    internal = true;
    readOnly = true;
    default = lib.getExe (
      pkgs.writeShellApplication {
        name = "pre-switch-checks";
        text = preSwitchCheckScript;
      }
    );
  };

  options.system.preSwitchChecks = lib.mkOption {
    default = { };
    example = lib.literalExpression ''
      { failsEveryTime =
        '''
          false
        ''';
      }
    '';

    description = ''
      A set of shell script fragments that are executed before the switch to a
      new NixOS system configuration. A failure in any of these fragments will
      cause the switch to fail and exit early.
      The scripts receive the new configuration path and the action verb passed
      to switch-to-configuration, as the first and second positional arguments
      (meaning that you can access them using `$1` and `$2`, respectively).
    '';

    type = lib.types.attrsOf lib.types.str;
  };
}
