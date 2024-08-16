# This test runs CRI-O and verifies via critest
import ./make-test-python.nix ({ pkgs, ... }: {
  name = "cri-o";
  meta.maintainers = with pkgs.lib; teams.podman.members;

  nodes = {
    crio = {
      virtualisation.cri-o.enable = true;
    };
  };

  testScript = ''
    start_all()
    crio.wait_for_unit("crio.service")
    crio.succeed(
        "critest --ginkgo.focus='Runtime info' --runtime-endpoint unix:///var/run/crio/crio.sock"
    )
  '';
})
