#!/usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils -p gawk

cat << EOF > "./flake-module-list.nix"
{
  notDetected = import ./installer/scan/not-detected.nix;
EOF

list=$(tr -d '[]' < ./module-list.nix)

for i in $list; do
  filenameWithExt="$(awk -F '/' 'BEGIN {OFS = "-"} {if (NF>2) {print $(NF-1),$NF} else {print $NF}}' <<< $i)"
  filename="${filenameWithExt%.*}"

  cat << EOF >> "./flake-module-list.nix"
  $filename = import $i;
EOF
done

cat << EOF >> "./flake-module-list.nix"
}
EOF
