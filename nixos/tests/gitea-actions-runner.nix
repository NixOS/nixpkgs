{ pkgs, ... }:
{
  name = "gitea-actions-runner";
  meta = {
    maintainers = pkgs.gitea-actions-runner.meta.maintainers;
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.gitea = {
        enable = true;
        database.type = "sqlite3";
        settings = {
          actions.ENABLED = true;
          service.DISABLE_REGISTRATION = true;
        };
      };

      services.gitea-actions-runner.instances = {
        host = {
          enable = true;
          name = "ci-host";
          url = "http://localhost:3000";
          labels = [ "native:host" ];
          tokenFile = "/var/lib/gitea/runner_token";
          settings.metrics = {
            enabled = true;
            addr = "127.0.0.1:9101";
          };
        };

        podman = {
          enable = true;
          name = "ci-podman";
          url = "http://localhost:3000";
          labels = [ "container:docker://test-image:latest" ];
          tokenFile = "/var/lib/gitea/runner_token";
          settings.metrics = {
            enabled = true;
            addr = "127.0.0.1:9102";
          };
        };
      };

      virtualisation.podman.enable = true;

      environment.systemPackages = [
        pkgs.gitea
        pkgs.gitMinimal
        pkgs.tea
      ];
    };

  testScript =
    let
      containerImage = pkgs.dockerTools.buildLayeredImage {
        name = "test-image";
        tag = "latest";
        contents = [
          pkgs.busybox
          pkgs.bashInteractive
        ];
      };

      ciWorkflow = pkgs.writeText "gitea-actions-runner-test-workflow.yaml" ''
        name: test
        on: [push]
        jobs:
          host:
            runs-on: native
            steps:
              - run: echo hello from the host runner
          container:
            runs-on: container
            steps:
              - run: echo hello from the podman runner
      '';
    in
    ''
      import json
      from typing import Any


      def gitea_admin(args: str) -> str:
          return machine.succeed(f"su -l gitea -c 'GITEA_WORK_DIR=/var/lib/gitea gitea {args}'")


      def tea_json(args: str) -> Any:
          output = machine.succeed(f"tea {args} --login test -o json").strip()
          if not output.startswith(("[", "{")):
              return []
          return json.loads(output)


      start_all()

      machine.wait_for_unit("gitea.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail http://localhost:3000/")

      gitea_admin("admin user create --username test --password hunter2 --email test@localhost")
      machine.succeed(
          "tea login add --url http://localhost:3000 --user test --password hunter2 -n test"
      )

      with subtest("Loading the test container image into podman"):
          machine.wait_for_unit("podman.socket")
          machine.succeed("podman load -i ${containerImage}")

      with subtest("Registering the runners"):
          token = gitea_admin("actions generate-runner-token").strip()
          machine.succeed(f"echo TOKEN={token} > /var/lib/gitea/runner_token")

          machine.wait_for_unit("gitea-runner-host.service")
          machine.wait_until_succeeds("curl --fail http://localhost:9101/readyz")
          machine.wait_until_succeeds("journalctl -u gitea-runner-host.service --grep 'Runner registered successfully'")

          machine.wait_for_unit("gitea-runner-podman.service")
          machine.wait_until_succeeds("curl --fail http://localhost:9102/readyz")
          machine.wait_until_succeeds("journalctl -u gitea-runner-podman.service --grep 'Runner registered successfully'")

      with subtest("Creating a repository with a workflow using both runners"):
          tea_json("repos create --name repo --init")
          machine.succeed(
              "tea api -X POST /repos/test/repo/contents/.gitea%2Fworkflows%2Ftest.yaml "
              + "--login test "
              + "-f branch=main "
              + '-f content="$(base64 -w0 ${ciWorkflow})" '
              + '-f message="Add CI workflow"'
          )

      with subtest("Waiting for both jobs to be picked up and run"):
          retry(lambda _: len(tea_json("actions runs list --repo test/repo --status success")) == 1)
    '';
}
