{
  lib,
  makeBinaryWrapper,
  writeShellApplication,
  bash,
  stdenv,
}:
{ defaultShellUtils }:
let
  defaultShellPath = lib.makeBinPath defaultShellUtils;

  bashWithDefaultShellUtilsSh = writeShellApplication {
    name = "bash";
    runtimeInputs = defaultShellUtils;
    # Empty PATH in Nixpkgs Bash is translated to /no-such-path
    # On other distros empty PATH search fallback is looking in standard
    # locations like /bin,/usr/bin
    # For Bazel many rules rely on such search finding some common utils,
    # so we provide them in case rules or arguments didn't specify a precise PATH
    text = ''
      if [[ "$PATH" == "/no-such-path" ]]; then
        export PATH=${defaultShellPath}
      fi
      exec ${bash}/bin/bash "$@"
    '';
  };

in
{
  inherit defaultShellUtils defaultShellPath;
  # Script-based interpreters in shebangs aren't guaranteed to work,
  # especially on MacOS. So let's produce a binary
  bashWithDefaultShellUtils = stdenv.mkDerivation {
    name = "bash";
    src = bashWithDefaultShellUtilsSh;
    nativeBuildInputs = [ makeBinaryWrapper ];
    buildPhase = ''
      makeWrapper ${bashWithDefaultShellUtilsSh}/bin/bash $out/bin/bash
    '';
  };
}
