{
  runCommand,
  jq,
  nix,
  nixosTests,
}:
let
  facterDebug = nixosTests.facter.nodes.machine.hardware.facter.debug;
  withFacter = nixosTests.facter.nodes.machine.system.build.toplevel;
  noFacter = nixosTests.facter.nodes.machine.system.build.noFacter.config.system.build.toplevel;
in
runCommand "facter-debug-nvd-test"
  {
    nativeBuildInputs = [
      facterDebug.nvd
      jq
      nix
    ];
    __structuredAttrs = true;
    unsafeDiscardReferences.out = true;
    exportReferencesGraph.withFacter = [ withFacter ];
    exportReferencesGraph.noFacter = [ noFacter ];
  }
  ''
    # Set up nix environment with read-only store but writable state
    mkdir -p "$TMPDIR/nix"/{var/nix,var/log/nix,etc}

    export NIX_REMOTE=""
    export NIX_STATE_DIR="$TMPDIR/nix/var/nix"
    export NIX_LOG_DIR="$TMPDIR/nix/var/log/nix"
    export NIX_CONF_DIR="$TMPDIR/nix/etc"
    cat > "$TMPDIR/nix/etc/nix.conf" <<EOF
    substituters =
    sandbox = false
    EOF

    # Initialize store database and register paths from exportReferencesGraph
    nix-store --init

    # Convert exportReferencesGraph JSON to nix-store --load-db format
    jq -r '(.withFacter + .noFacter)[] | "\(.path)\n\(.narHash)\n\(.narSize)\n\n\(.references | length)\(if .references | length > 0 then "\n" + (.references | join("\n")) else "" end)"' \
      < "$NIX_ATTRS_JSON_FILE" | nix-store --load-db

    # Run nvd and verify it produces output
    facter-nvd-diff > nvd-output.txt
    if [ ! -s nvd-output.txt ]; then
      echo "facter-nvd-diff produced no output"
      exit 1
    fi
    cat nvd-output.txt
    echo "nvd debug utility works correctly" > $out
  ''
