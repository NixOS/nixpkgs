{ lib, pkgs, ... }:
let
  # act starts job containers with `tail -f /dev/null` and runs steps in bash.
  # The marker file shows that the step ran inside the container.
  image = pkgs.dockerTools.buildImage {
    name = "localhost/act-test";
    tag = "latest";
    copyToRoot = pkgs.buildEnv {
      name = "act-test-root";
      paths = [
        pkgs.bash
        pkgs.coreutils
        (pkgs.writeTextDir "etc/act-test" "act-test")
      ];
      pathsToLink = [
        "/bin"
        "/etc"
      ];
    };
  };

  workflow = pkgs.writeText "test.yml" ''
    on: push
    jobs:
      test:
        runs-on: ubuntu-latest
        steps:
          - run: echo "hello from the $(cat /etc/act-test) container"
  '';

  common = {
    programs.act.enable = true;
    environment.systemPackages = [ pkgs.git ];
    users.users.alice.isNormalUser = true;
  };
in
{
  name = "act";
  meta.maintainers = with lib.maintainers; [ yiyu ];

  nodes = {
    docker = {
      imports = [ common ];
      users.users.alice.extraGroups = [ "docker" ];
    };

    # Docker and an unwrapped act are installed too, which would bypass Podman
    podman = {
      imports = [ common ];
      programs.act.backend = "podman";
      virtualisation.docker.enable = true;
      environment.systemPackages = [ pkgs.act ];
    };
  };

  testScript = ''
    import shlex


    def su_cmd(cmd, user="alice"):
        return f"su {user} -l -c {shlex.quote(cmd)}"


    def run_workflow(machine, engine):
        machine.succeed(su_cmd(f"{engine} load --input ${image}"))
        machine.succeed(
            su_cmd(
                "mkdir -p repo/.github/workflows"
                " && cp ${workflow} repo/.github/workflows/test.yml"
                " && git -C repo init --quiet"
                " && git -C repo add ."
                " && git -C repo -c user.name=alice -c user.email=alice@localhost commit --quiet -m init"
            )
        )
        output = machine.succeed(
            su_cmd("cd repo && act --pull=false -P ubuntu-latest=localhost/act-test:latest 2>&1")
        )
        print(output)
        assert "hello from the act-test container" in output, f"workflow did not run with {engine}"


    start_all()

    docker.wait_for_unit("sockets.target")
    run_workflow(docker, "docker")

    podman.wait_for_unit("sockets.target")
    podman.succeed("loginctl enable-linger alice")
    podman.wait_for_unit("user@1000.service")
    podman.wait_for_unit("podman.socket", "alice")
    run_workflow(podman, "podman")
  '';
}
