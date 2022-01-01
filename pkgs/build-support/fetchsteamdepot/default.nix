{ lib
, runCommand
, writeText
, cacert
, depotdownloader }:

{ name, appId, depotId, manifestId, branch ? null, sha256, fileList ? [] }:

let fileListFile = writeText "steam-filelist-${name}.txt" (builtins.concatStringsSep "\n" fileList);
in with lib; runCommand "${name}-src" {
  buildInputs = [ cacert depotdownloader ];
  inherit appId depotId manifestId;
  outputHashAlgo = "sha256";
  outputHash = sha256;
  outputHashMode = "recursive";
} ''
  HOME=$TMPDIR DepotDownloader -app "$appId" -depot "$depotId" -manifest "$manifestId" \
    ${optionalString (fileList != []) "-filelist \"${fileListFile}\""} \
    ${optionalString (branch != null) "-branch \"${branch}\""} -dir "$out"
  rm -r "$out/.DepotDownloader"
''
