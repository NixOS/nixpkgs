import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "isolate";
    meta.maintainers = with lib.maintainers; [ virchau13 ];

    nodes.machine =
      { ... }:
      {
        security.isolate = {
          enable = true;
        };
      };

    testScript = ''
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
    '';
  }
)
