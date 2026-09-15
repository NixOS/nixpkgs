{
  config,
  hostPkgs,
  lib,
  ...
}:
let
  runInQemu = (
    # Could it be useful on linux without `uid-range` builders?..
    hostPkgs.stdenv.hostPlatform.isDarwin && (config.containers != { } && config.nodes == { })
  );

  wrappedTest = (import ./default.nix { inherit lib; }).runTest {
    name = config.name;
    hostPkgs = hostPkgs;
    nodeDefaults = config.nodeDefaults;

    # Qemu tests grant 1GiB; allocate some more for nspawn infra and,
    # potentially, multiple containers.
    nodes.runner.virtualisation.memorySize = lib.mkDefault 2048;

    globalTimeout = config.globalTimeout;
    meta = lib.removeAttrs config.meta [
      "maintainersPosition"
      "teamsPosition"
    ];

    testScript =
      { nodes, ... }:
      let
        sharedDir = nodes.runner.virtualisation.sharedDirectories.shared.target;
      in
      ''
        import shutil

        runner.start()
        runner.succeed(
            "${lib.getExe config.driver} -o ${lib.escapeShellArg sharedDir} 2>&1 "
            "| tee /dev/console >/dev/null",
            timeout=None,
        )
        shutil.copytree(runner.shared_dir, driver.out_dir, dirs_exist_ok=True)
      '';

    passthru.driverInteractive = lib.mkForce (
      throw "Interactive nspawn tests are not supported on Darwin"
    );
  };
in
{
  config = lib.mkIf runInQemu {
    testDriverPkgs = hostPkgs.pkgsLinux;
    test = lib.mkForce wrappedTest;
  };
}
