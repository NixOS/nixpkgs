{
  lib,
  stdenvNoCC,
  pijul,
  cacert,
}:

lib.makeOverridable (
  {
    # Remote to fetch
    url,
    # Additional list of remotes specifying alternative download location to be
    # tried in order, if the prior remote failed to fetch.
    mirrors ? [ ],
    hash ? "",
    change ? null,
    state ? null,
    channel ? "main",
    name ? "fetchpijul",
  # TODO: Changes in pijul are unordered so there's many ways to end up with the same repository state.
  # This makes leaveDotPijul unfeasible to implement until pijul CLI implements
  # a way of reordering changes to sort them in a consistent and deterministic manner.
  # leaveDotPijul ? false
  }:
  if change != null && state != null then
    throw "Only one of 'change' or 'state' can be set"
  else
    stdenvNoCC.mkDerivation {
      inherit name;
      nativeBuildInputs = [
        pijul
        cacert
      ];
      strictDeps = true;

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        success=
        for remote in $remotes; do
          if
            pijul clone \
              ''${change:+--change "$change"} \
              ''${state:+--state "$state"} \
              --channel "$channel" \
              "$remote" \
              "$out"
          then
            success=1
            break
          fi
        done

        if [ -z "$success" ]; then
          echo "Error: couldn’t clone remote from any mirror" 1>&2
          exit 1
        fi

        runHook postInstall
      '';

      fixupPhase = ''
        runHook preFixup

        rm -rf "$out/.pijul"

        runHook postFixup
      '';

      outputHashAlgo = null;
      outputHashMode = "recursive";
      outputHash = if hash != "" then hash else lib.fakeHash;

      inherit
        change
        state
        channel
        ;

      remotes = [ url ] ++ mirrors;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;
    }
)
