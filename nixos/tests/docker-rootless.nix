# This test runs docker and checks if simple container starts

import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "docker-rootless";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ abbradar ];
    };

    nodes = {
      machine =
        { pkgs, ... }:
        {
          virtualisation.docker.rootless.enable = true;

          users.users.alice = {
            uid = 1000;
            linger = true;
            isNormalUser = true;
          };
        };
    };

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.config.users.users.alice;
        runtimeUID = "$(id -u ${user.name})";
        runtimeDir = "/run/user/${runtimeUID}";
        sudo = lib.concatStringsSep " " [
          "XDG_RUNTIME_DIR=${runtimeDir}"
          "DOCKER_HOST=unix://${runtimeDir}/docker.sock"
          "sudo"
          "--preserve-env=XDG_RUNTIME_DIR,DOCKER_HOST"
          "-u"
          user.name
        ];
      in
      ''
        machine.wait_for_unit("multi-user.target")

        machine.wait_for_unit("user@${runtimeUID}")
        machine.wait_for_unit("docker.service", "${user.name}")

        machine.succeed("tar cv --files-from /dev/null | ${sudo} docker import - scratchimg")
        machine.succeed(
            "${sudo} docker run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
        )
        machine.succeed("${sudo} docker ps | grep sleeping")
        machine.succeed("${sudo} docker stop sleeping")
      '';
  }
)
