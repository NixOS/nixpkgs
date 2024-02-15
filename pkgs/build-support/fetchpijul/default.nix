{ lib, stdenvNoCC, pijul, cacert }:

lib.makeOverridable (
{ url
, hash ? ""
, change ? null
, state ? null
, channel ? "main"
, name ? "fetchpijul"
, # TODO: Changes in pijul are unordered so there's many ways to end up with the same repository state.
  # This makes leaveDotPijul unfeasible to implement until pijul CLI implements
  # a way of reordering changes to sort them in a consistent and deterministic manner.
  # leaveDotPijul ? false
}:
if change != null && state != null then
  throw "Only one of 'change' or 'state' can be set"
else
  stdenvNoCC.mkDerivation {
    inherit name;
    nativeBuildInputs = [ pijul cacert ];
    strictDeps = true;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      pijul clone \
        ''${change:+--change "$change"} \
        ''${state:+--state "$state"} \
        --channel "$channel" \
        "$url" \
        "$out"

      runHook postInstall
    '';

    fixupPhase = ''
      runHook preFixup

      rm -rf "$out/.pijul"

      runHook postFixup
    '';

    outputHashAlgo = if hash != "" then null else "sha256";
    outputHashMode = "recursive";
    outputHash = if hash != "" then
      hash
    else
      lib.fakeSha256;

    inherit url change state channel;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;
  }
)
