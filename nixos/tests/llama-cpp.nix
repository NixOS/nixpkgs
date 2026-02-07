{ lib, pkgs, ... }:
{
  name = "llama-cpp";
  meta.maintainers = with lib.maintainers; [ newam ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.llama-cpp ];

      services.llama-cpp = {
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
    machine.wait_for_unit("multi-user.target")

    machine.succeed("llama-server --help")

    unit = machine.succeed("systemctl cat llama-cpp.service")
    print(f"Service unit:\n{unit}")

    for directive in [
        "DynamicUser=true",
        "NoNewPrivileges=true",
        "ProtectSystem=strict",
        "CapabilityBoundingSet=",
        "StateDirectory=llama-cpp",
        "CacheDirectory=llama-cpp",
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
  '';
}
