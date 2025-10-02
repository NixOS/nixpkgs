# This test runs docker and checks if simple container starts
{ lib, pkgs, ... }:
{
  name = "docker-rootless";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    machine =
      { pkgs, ... }:
      {
        virtualisation.docker.rootless.enable = true;

        users.users.alice = {
          uid = 1000;
          isNormalUser = true;
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.config.users.users.alice;
      sudo = lib.concatStringsSep " " [
        "XDG_RUNTIME_DIR=/run/user/${toString user.uid}"
        "DOCKER_HOST=unix:///run/user/${toString user.uid}/docker.sock"
        "sudo"
        "--preserve-env=XDG_RUNTIME_DIR,DOCKER_HOST"
        "-u"
        "alice"
      ];
    in
    ''
      machine.wait_for_unit("multi-user.target")

      machine.succeed("loginctl enable-linger alice")
      machine.wait_until_succeeds("${sudo} systemctl --user is-active docker.service")

      machine.succeed("tar cv --files-from /dev/null | ${sudo} docker import - scratchimg")
      machine.succeed(
          "${sudo} docker run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
      )
      machine.succeed("${sudo} docker ps | grep sleeping")
      machine.succeed("${sudo} docker stop sleeping")
    '';
}
