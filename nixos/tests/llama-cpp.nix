{ lib, pkgs, ... }:
{
  name = "llama-cpp";
  meta.maintainers = with lib.maintainers; [ newam ];

  nodes.legacy =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.llama-cpp ];

      # Legacy single-instance API (backward-compatible with master branch)
      services.llama-cpp = {
        enable = true;
        model = "/nonexistent.gguf";
        extraFlags = [
          "-c"
          "2048"
        ];
      };
    };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.llama-cpp ];

      services.llama-cpp.instances.test = {
        enable = true;
        # Model path does not need to exist — we're testing module
        # evaluation and service unit configuration, not inference.
        model = "/nonexistent.gguf";
        gpuLayers = 33;
        contextSize = 2048;
        parallel = 4;
        threads = 8;
        batchSize = 512;
        flashAttention = "auto";
        mlock = true;
        embedding = true;
        enableMetrics = true;
        alias = "test-model";
      };
    };

  testScript = ''
    # --- Legacy single-instance API ---
    legacy.wait_for_unit("multi-user.target")

    legacy.succeed("llama-server --help")

    legacy_unit = legacy.succeed("systemctl cat llama-cpp.service")
    print(f"Legacy service unit:\n{legacy_unit}")

    # Service must be named llama-cpp (no suffix, not llama-cpp-)
    legacy.succeed("systemctl cat llama-cpp.service")

    for directive in [
        "DynamicUser=true",
        "NoNewPrivileges=true",
        "ProtectSystem=strict",
        "CapabilityBoundingSet=",
        "StateDirectory=llama-cpp",
        "CacheDirectory=llama-cpp",
    ]:
        assert directive in legacy_unit, f"Missing {directive} in legacy service unit"

    # StateDirectory must not have a trailing dash
    assert "StateDirectory=llama-cpp-" not in legacy_unit, \
        "Legacy service should not have trailing dash in StateDirectory"

    assert "PrivateDevices=true" in legacy_unit, \
        "CPU-only build should have PrivateDevices=true"

    # extraFlags should be reflected in ExecStart
    assert "-c" in legacy_unit, "extraFlags -c not in ExecStart"

    # Verify llama-cpp-verify is installed
    legacy.succeed("command -v llama-cpp-verify")
    legacy_verify = legacy.succeed("cat $(command -v llama-cpp-verify)")
    assert "default:" in legacy_verify or "llama-cpp:" in legacy_verify, \
        "verify script should contain legacy instance data"

    # --- Multi-instance API ---
    machine.wait_for_unit("multi-user.target")

    machine.succeed("llama-server --help")

    unit = machine.succeed("systemctl cat llama-cpp-test.service")
    print(f"Service unit:\n{unit}")

    for directive in [
        "DynamicUser=true",
        "NoNewPrivileges=true",
        "ProtectSystem=strict",
        "CapabilityBoundingSet=",
        "StateDirectory=llama-cpp-test",
        "CacheDirectory=llama-cpp-test",
    ]:
        assert directive in unit, f"Missing {directive} in service unit"

    assert "PrivateDevices=true" in unit, \
        "CPU-only build should have PrivateDevices=true"

    assert "DeviceAllow" not in unit, \
        "CPU-only build should not have DeviceAllow rules"

    for flag in [
        "--metrics",
        "--ctx-size",
        "--gpu-layers",
        "--parallel",
        "--threads",
        "--batch-size",
        "--flash-attn",
        "--mlock",
        "--embedding",
        "--alias",
    ]:
        assert flag in unit, f"Typed option {flag} not reflected in ExecStart"

    # Verify llama-cpp-verify is installed and config-aware
    machine.succeed("command -v llama-cpp-verify")
    verify_script = machine.succeed("cat $(command -v llama-cpp-verify)")
    assert "test:" in verify_script, \
        "verify script should contain instance name 'test'"
  '';
}
