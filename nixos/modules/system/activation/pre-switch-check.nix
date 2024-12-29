{ lib, pkgs, ... }:
let
  preSwitchCheckScript =
    set:
    lib.concatLines (
      lib.mapAttrsToList (name: text: ''
        # pre-switch check ${name}
        (
          ${text}
        )
        if [[ $? != 0 ]]; then
          echo "Pre-switch check '${name}' failed"
          exit 1
        fi
      '') set
    );
in
{
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
    '';

    type = lib.types.attrsOf lib.types.str;

    apply =
      set:
      set
      // {
        script = pkgs.writeShellScript "pre-switch-checks" (preSwitchCheckScript set);
      };
  };
}
