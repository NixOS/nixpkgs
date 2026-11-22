{
  runCommand,
  nushell,
  nushellPlugins,
}:
let
  nuWithPlugins = nushell.withPlugins (
    with nushellPlugins;
    [
      formats
      polars
    ]
  );
in
runCommand "nushell-with-plugins-test" { } ''
    mkdir $out

    # Verify that a wrapped nushell loads plugins without XDG_DATA_DIRS
    # and/or a config, etc.
    output=$(env -u XDG_DATA_DIRS HOME=/homeless-shelter ${nuWithPlugins}/bin/nu --no-config-file -c "'a=1
  b=2' | from ini | to json")

    if ! echo "$output" | grep -q '"a": "1"'; then
      echo "FAIL: formats plugin did not load: 'from ini' produced no expected output."
      echo "--- output ---"
      echo "$output"
      exit 1
    fi
''
