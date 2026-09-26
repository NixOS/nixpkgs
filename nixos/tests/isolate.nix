{ lib, ... }:
{
  name = "isolate";
  meta.maintainers = with lib.maintainers; [
    virchau13
    hey2022
  ];

  nodes = {
    machine = {
      security.isolate = {
        enable = true;
      };
    };

    overridden =
      { pkgs, ... }:
      {
        security.isolate = {
          enable = true;

          package = pkgs.isolate.overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              touch $out/package-override-marker
            '';
          });
        };
      };

    securityWrapped = { config, ... }: {
      security.isolate.enable = true;
      users.groups.test = { };
      users.users.test = {
        isSystemUser = true;
        group = "test";
      };
      security.wrappers.isolate = {
        source = lib.getExe config.security.isolate.finalPackage;
        owner = "root";
        group = "test";
        setuid = true;
        permissions = "u+rx,g+x";
      };
    };
  };

  testScript =
    { nodes, ... }:
    let
      finalPackage = nodes.machine.security.isolate.finalPackage;
      overriddenFinalPackage = nodes.overridden.security.isolate.finalPackage;
    in
    ''
      bash_path = machine.succeed('realpath $(which bash)').strip()
      sleep_path = machine.succeed('realpath $(which sleep)').strip()

      def sleep_test(walltime, sleeptime):
          return f'isolate --no-default-dirs --wall-time {walltime} ' + \
              f'--dir=/box={box_path} --dir=/nix=/nix --run -- ' + \
              f"{bash_path} -c 'exec -a sleep {sleep_path} {sleeptime}'"

      def sleep_test_cg(walltime, sleeptime):
          return f'isolate --cg --no-default-dirs --wall-time {walltime} ' + \
              f'--dir=/box={box_path} --dir=/nix=/nix --processes=2 --run -- ' + \
              f"{bash_path} -c '( exec -a sleep {sleep_path} {sleeptime} )'"

      with subtest("without cgroups"):
          box_path = machine.succeed('isolate --init').strip()
          machine.succeed(sleep_test(1, 0.5))
          machine.fail(sleep_test(0.5, 1))
          machine.succeed('isolate --cleanup')
      with subtest("with cgroups"):
          box_path = machine.succeed('isolate --cg --init').strip()
          machine.succeed(sleep_test_cg(1, 0.5))
          machine.fail(sleep_test_cg(0.5, 1))
          machine.succeed('isolate --cg --cleanup')

      with subtest("finalPackage"):
          isolate_path = machine.succeed("realpath $(which isolate)").strip()
          t.assertEqual(isolate_path, "${lib.getExe finalPackage}")
      with subtest("package override"):
          overridden.succeed("test -e ${overriddenFinalPackage}/package-override-marker")
          isolate_path = overridden.succeed("realpath $(which isolate)").strip()
          t.assertEqual(isolate_path, "${lib.getExe overriddenFinalPackage}")

      with subtest("setuid security wrapper"):
          securityWrapped.succeed("sudo -u test -g test isolate --init")
          securityWrapped.succeed("sudo -u test -g test isolate --cleanup")
    '';
}
