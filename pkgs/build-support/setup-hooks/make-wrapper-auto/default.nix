{ lib
, dieHook
, makeSetupHook
, jq
}:

(makeSetupHook {
  deps = [ dieHook ];
  substitutions = {
    jq = "${lib.getBin jq}/bin/jq";
  };
} ./hook.sh).overrideAttrs(old: {
  passthru.combineWrappersInfo = { envInfo
    , symlink ? {}
    , buildInputs ? []
    , propagatedBuildInputs ? []
  }: let
    inputsWrapInfo = lib.concatStringsSep " " (
      builtins.map (input: "${lib.getDev input}/nix-support/wrappers.json") (
        buildInputs ++ propagatedBuildInputs
      )
    );
    envInfoFile = builtins.toFile "env-info.json" (builtins.toJSON envInfo);
  in /* bash */ ''
    # Make sure this evaluates if there are no multiple outputs.
    mkdir -p $dev/nix-support
    # TODO: Handle symlink requests
    local wrapInfo
    local -a inputs_wrap_info
    for wrapInfo in ${inputsWrapInfo}; do
      if [[ -f "$wrapInfo" ]]; then
        inputs_wrap_info+=($wrapInfo)
      else
        echo did not find file $wrapInfo
      fi
    done
    # TODO: Is this the best way to substitute @out@ with $out?
    ${jq}/bin/jq "." ${envInfoFile} $inputs_wrap_info | sed "s#@out@#$out#g" > $dev/nix-support/wrappers.json
    ${jq}/bin/jq . $dev/nix-support/wrappers.json
  '';
})
