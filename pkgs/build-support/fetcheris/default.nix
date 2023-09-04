{ stdenvNoCC, eris-go, writeScript }:

{ name, urn, erisStores ? [ ], hash ? "", alternateInstructions ? "", meta ? { }
, postFetch ? "", preferLocalBuild ? true }:

stdenvNoCC.mkDerivation {
  inherit name erisStores meta postFetch preferLocalBuild urn;
  impureEnvVars = [ "ERIS_STORE_URL" ];
  nativeBuildInputs = [ eris-go ];
  outputHash = hash;
  outputHashAlgo = if hash != "" then null else "sha256";
  outputHashMode = "flat";
  builder = writeScript "fetcheris-builder.sh" ''
    if [ -e .attrs.sh ]; then source .attrs.sh; fi
    source $stdenv/setup

    exit_with_message() {
    cat << _EOF_ >&2
    fetchEris failed!
    ${alternateInstructions}
    _EOF_
    exit 1
    }

    trap exit_with_message ERR

    echo fetch from "$ERIS_STORE_URL" "$erisStores"
    eris-go get "$ERIS_STORE_URL" "$erisStores" "$urn" > $out

    runHook postFetch
  '';
}
