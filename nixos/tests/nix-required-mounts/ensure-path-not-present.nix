{
  pkgs ? import <nixpkgs> { },
  feature,
}:

pkgs.runCommand "${feature}-not-present" { } ''
  if [[ -e /${feature}-files ]]; then
    echo "No ${feature} in requiredSystemFeatures, but /${feature}-files was mounted anyway"
    exit 1
  else
    touch $out
  fi
''
