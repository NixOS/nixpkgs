{
  pkgs ? import <nixpkgs> { },
  feature,
}:

pkgs.runCommand "${feature}-present" { requiredSystemFeatures = [ feature ]; } ''
  if [[ ! -e /${feature}-files ]]; then
    echo "The host declares ${feature} support, but doesn't expose /${feature}-files" >&2
    exit 1
  fi
  libcudaLocation=/run/opengl-driver/lib/libcuda.so
  if [[ -e "$libcudaLocation" || -h "$libcudaLocation" ]] ; then
    true # we're good
  else
    echo "The host declares ${feature} support, but it the hook fails to handle the hostPath != guestPath cases" >&2
    exit 1
  fi
  if cat "$libcudaLocation" | xargs test fakeContent = ; then
    true # we're good
  else
    echo "The host declares ${feature} support, but it seems to fail to follow symlinks" >&2
    echo "The content of /run/opengl-driver/lib/libcuda.so is: $(cat /run/opengl-driver/lib/libcuda.so)" >&2
    exit 1
  fi
  touch $out
''
