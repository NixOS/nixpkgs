#!/usr/bin/env bash

targetDir="$1"
dllFullPath="$2"

dllVersion="$(monodis --assembly "$dllFullPath" | grep ^Version: | cut -f 2 -d : | xargs)"
[ -z "$dllVersion" ] && echo "Defaulting dllVersion to 0.0.0" && dllVersion="0.0.0"
dllFileName="$(basename $dllFullPath)"
dllRootName="$(basename -s .dll $dllFileName)"
targetPcFile="$targetDir"/"$dllRootName".pc

mkdir -p "$targetDir"

cat > $targetPcFile << EOF
Libraries=$dllFullPath

Name: $dllRootName
Description: $dllRootName
Version: $dllVersion
Libs: -r:$dllFileName
EOF

echo "Created $targetPcFile"
