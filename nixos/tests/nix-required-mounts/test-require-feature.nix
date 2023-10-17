{ pkgs ? import <nixpkgs> { }, feature }:

pkgs.runCommandNoCC "${feature}-present"
{
  requiredSystemFeatures = [ feature ];
} ''
  if [[ -e /${feature}-files ]]; then
    touch $out
  else
    echo "The host declares ${feature} support, but doesn't expose /${feature}-files" >&2
  fi
''
