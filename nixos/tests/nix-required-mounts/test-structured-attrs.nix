{
  pkgs ? import <nixpkgs> { },
  feature,
}:

pkgs.runCommandNoCC "${feature}-present-structured"
  {
    __structuredAttrs = true;
    requiredSystemFeatures = [ feature ];
  }
  ''
    if [[ -e /${feature}-files ]]; then
      touch $out
    else
      echo "The host declares ${feature} support, but doesn't expose /${feature}-files" >&2
      echo "Do we fail to parse __structuredAttrs=true derivations?" >&2
    fi
  ''
