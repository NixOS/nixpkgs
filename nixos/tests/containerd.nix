# This test runs containerd and checks if simple container starts

import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "containerd";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ jlesquembre ];
  };

  nodes = {
    machine = { pkgs, ... }: {
      virtualisation.containerd.enable = true;
      virtualisation.containerd.nerdctl.portDriver = "slirp4netns";

      users.users.alice = {
        uid = 1000;
        isNormalUser = true;
        password = "";
      };
    };
  };

  testScript = { nodes, ... }:
    let
      user = nodes.machine.config.users.users.alice;
      runtimeDir = "/run/user/${toString user.uid}";
      sudo = lib.concatStringsSep " " [
        "XDG_RUNTIME_DIR=${runtimeDir}"
        "sudo"
        "--preserve-env=XDG_RUNTIME_DIR"
        "-u"
        "alice"
      ];
    in
    ''
      machine.wait_for_unit("multi-user.target")

      machine.succeed("loginctl enable-linger alice")
      machine.wait_until_succeeds("${sudo} systemctl --user is-active containerd.service")
      machine.wait_until_succeeds("${sudo} systemctl --user is-active buildkit.service")
      machine.wait_for_file("${runtimeDir}/containerd-rootless/child_pid")
      machine.wait_for_file("${runtimeDir}/buildkit/buildkitd.sock")

      machine.succeed("echo 'FROM scratch' > Dockerfile",
                      "${sudo} nerdctl build -t scratchimg .")
      machine.succeed(
          "${sudo} nerdctl run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
      )
      machine.succeed("${sudo} nerdctl ps | grep sleeping")
      machine.succeed("${sudo} nerdctl stop sleeping")
    '';
})
