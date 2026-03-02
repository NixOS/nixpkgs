{
  lib,
  lanzaboote-tool,
  runCommand,
}:
runCommand "help" { } ''
  set -euo pipefail

  ${lib.getExe lanzaboote-tool} --help

  touch $out
''
