# `makePhase`
#
# This functions allows one to define a phase declaratively.

{ lib
, makeSetupHook
}:


{ name
, function
, requires ? []
, before ? []
, after ? []
, disabledWhen ? [ ]
, replaces ? null
, makeSetupHookAttrs ? {}
} @ attrs:

let

  before_ = lib.concatMapStringsSep ";" (phase: "addPhase ${phase} ${name}") before;
  after_ = lib.concatMapStringsSep ";" (phase: "addPhase ${name} ${phase}") after;

  disabled_ = attribute: ''
    if []
  '';

  disabledWhen_ = lib.concatMapStringsSep ";" (attr: "[ -z \"${attr}- \"]");

  script = ''
    echo "Sourcing the script defining ${name}".

    ${name} () {
      # TODO runHook
      ${function}
      # TODO runHook
    }

  ${before_}
  ${after_}

  '' + lib.optionalString (replaces != null) ''
    echo "Substituting ${replaces} with ${name}".
    ${replaces}=${name}
  '' + ''
  echo "Finished sourcing the script defining ${name}".
  '';

in makeSetupHook (makeSetupHookAttrs // {
  inherit name;
  deps = requires ++ (makeSetupHookAttrs.deps or []);
  passthru = {
    inherit script;
  };
}) script
