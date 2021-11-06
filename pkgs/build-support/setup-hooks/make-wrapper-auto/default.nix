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
        builtins.filter (x: !builtins.isNull x) (buildInputs ++ propagatedBuildInputs)
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
      fi
    done
    # TODO: Is this the best way to substitute @out@ with $out?
    # TODO: How to merge json files according to keys? See:
    # https://stackoverflow.com/q/69862320/4935114
    ${jq}/bin/jq "." ${envInfoFile} $inputs_wrap_info | sed \
      -e "s,@out@,$out,g" \
      -e "s,@bin@,$bin,g" \
      -e "s,@lib@,$lib,g" \
      > $dev/nix-support/wrappers.json
    # Display the file
    ${jq}/bin/jq . $dev/nix-support/wrappers.json
  '';
})
