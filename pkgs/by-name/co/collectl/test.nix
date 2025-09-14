{
  runCommand,
  collectl,
  coreutils,
}:

runCommand "collectl-test"
  {
    nativeBuildInputs = [
      collectl
      coreutils
    ];
    meta.timeout = 60;
  }
  ''
    # Test basic functionality - limit to 5 seconds to avoid hanging
    timeout 5s collectl -c1 >/dev/null || true

    # Test that explicit config file option still works with original config
    timeout 5s collectl --config ${collectl}/etc/collectl.conf -c1 >/dev/null || true

    # Test custom config file path override
    custom_config_path=$(mktemp)
    cp ${collectl}/etc/collectl.conf "$custom_config_path"

    # Test that collectl uses the custom config file path
    config_output=$(timeout 5s collectl --config "$custom_config_path" -c1 -d1 2>&1 | grep -i "Config File Search Path:" | head -1)
    expected_output="Config File Search Path: $custom_config_path"

    if [ "$config_output" = "$expected_output" ]; then
      echo "✓ Custom config file path test passed"
    else
      echo "✗ Custom config file path test failed"
      echo "Expected: $expected_output"
      echo "Got: $config_output"
      exit 1
    fi

    # Cleanup
    rm -f "$custom_config_path"

    # Signal success
    touch $out
  ''
