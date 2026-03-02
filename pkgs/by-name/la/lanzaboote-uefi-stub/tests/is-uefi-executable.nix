{
  coreutils,
  file,
  lib,
  lanzaboote-uefi-stub,
  runCommand,
}:
runCommand "is-uefi-executable"
  {
    nativeBuildInputs = [
      coreutils # grep
      file
    ];
  }
  ''
    set -euo pipefail

    file ${lib.getExe lanzaboote-uefi-stub} | tee /proc/self/fd/2 | grep -q 'PE32+ executable for EFI (application)'

    touch $out
  ''
