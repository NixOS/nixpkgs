{ lib, makeSetupHook, writeScript, makeWrapper, xi-core }:

makeSetupHook {
  name = "wrapXiFrontend-hook";
  deps = [ makeWrapper ]; 
} (writeScript "wrapXiFrontend" ''
  wrapXiFrontend() {
    for x in "$@"; do
      wrapProgram "$x" \
        --prefix PATH : ${lib.makeBinPath [ xi-core ]}
    done
  }
'')
