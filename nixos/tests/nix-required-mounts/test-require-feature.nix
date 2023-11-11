{ pkgs ? import <nixpkgs> { }, feature }:

pkgs.runCommandNoCC "${feature}-present"
{
  requiredSystemFeatures = [ feature ];
} ''
  if [[ ! -e /${feature}-files ]]; then
    echo "The host declares ${feature} support, but doesn't expose /${feature}-files" >&2
    exit 1
  fi
  if [[ ! -f /run/opengl-driver/lib/libcuda.so ]] ; then
    echo "The host declares ${feature} support, but it the hook fails to handle the hostPath != guestPath cases" >&2
    exit 1
  fi
  touch $out
''
