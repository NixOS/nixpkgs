{ pkgs, ... }:
let
  inherit (import ./common.nix) baseConfig;
in
{
  name = "hydra";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lewo ];
  };

  nodes.machine =
    { pkgs, lib, ... }:
    {
      imports = [ baseConfig ];
    };

  testScript = ''
    # let the system boot up
    machine.wait_for_unit("multi-user.target")
    # test whether the database is running
    machine.wait_for_unit("postgresql.target")
    # test whether the actual hydra daemons are running
    machine.wait_for_unit("hydra-init.service")
    machine.wait_for_unit("hydra-queue-runner.service")
    machine.require_unit_state("hydra-evaluator.service")
    machine.require_unit_state("hydra-notify.service")
    machine.wait_for_open_port(50051)
    machine.wait_for_unit("hydra-builder.service")
    machine.wait_for_unit("hydra-ws.service")

    machine.succeed("hydra-create-user admin --role admin --password admin")

    # create a project with a trivial job
    machine.wait_for_open_port(3000)

    # make sure the build as been successfully built
    machine.succeed("create-trivial-project.sh")

    machine.wait_until_succeeds(
        'curl -L -s http://localhost:3000/build/1 -H "Accept: application/json" |  jq .buildstatus | xargs test 0 -eq'
    )

    # The web interface reads the machine list from the queue runner's REST
    # endpoint, which it only knows about through `queue_runner_endpoint` in
    # hydra.conf.
    machine.wait_until_succeeds(
        'curl -L -s http://localhost:3000/machines -H "Accept: application/json" | jq -e "length > 0"'
    )

    machine.wait_until_succeeds(
        'journalctl -eu hydra-notify.service -o cat | grep -q "sending mail notification for changed build status to hydra@localhost"'
    )

    # Build a derivation through hydra-ad-hoc: the queue runner builds it as a
    # Hydra build of the hidden adhoc/adhoc jobset.
    machine.wait_for_unit("hydra-ad-hoc.socket")
    drv = machine.succeed("nix-instantiate /etc/hydra-test/ad-hoc.nix").strip()
    out = machine.succeed(
        f"nix-store --store unix:///run/hydra-ad-hoc/socket --realise {drv}"
    ).strip()
    machine.succeed(f"grep -q 'hello from hydra-ad-hoc' {out}")
    machine.succeed(
        'curl -L -s http://localhost:3000/jobset/adhoc/adhoc -H "Accept: application/json" | jq -e .name'
    )
  '';
}
