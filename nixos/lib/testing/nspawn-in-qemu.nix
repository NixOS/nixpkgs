{
  config,
  hostPkgs,
  lib,
  ...
}:
let
  runInQemu = (
    hostPkgs.stdenv.hostPlatform.isDarwin && (config.containers != { } && config.nodes == { })
  );

  wrappedTest = (import ./default.nix { inherit lib; }).runTest {
    inherit hostPkgs;
    inherit (config)
      name
      nodeDefaults
      globalTimeout
      ;

    # Qemu tests grant 1GiB; allocate some more for nspawn infra and,
    # potentially, multiple containers.
    nodes.runner.virtualisation.memorySize = lib.mkDefault 2048;

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
            "${lib.getExe config.driver} --output_directory ${lib.escapeShellArg sharedDir} 2>&1 "
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
