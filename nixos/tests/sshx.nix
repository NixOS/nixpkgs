{ lib, pkgs, ... }:

{
  name = "sshx";

  nodes.machine.services.sshx.enable = true;

  testScript = { nodes, ... }: ''
    machine.wait_for_unit("sshx.service")
    machine.execute(
      """
      timeout 5 ${lib.getExe pkgs.sshx} \
        --server http://${nodes.machine.services.sshx.settings.listenAddress}:${toString nodes.machine.services.sshx.settings.port} \
        --shell ${lib.getExe pkgs.bashInteractive} > output
      """,
      check_return = False
    )
    machine.succeed("grep '${lib.getExe pkgs.bashInteractive}' output >&2")
  '';
}
