{
  lib,
  runCommand,
  ratchet,
}: let
  inherit (ratchet) pname version;
in
  runCommand "${pname}-tests" {meta.timeout = 60;}
  ''
    set -euo pipefail

    # Ensure ratchet is executable
    ${ratchet}/bin/ratchet --version
    ${ratchet}/bin/ratchet --help

    touch $out
  ''
