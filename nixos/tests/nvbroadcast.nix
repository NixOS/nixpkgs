{ ... }:
{
  name = "nvbroadcast";

  meta.timeout = 600;

  nodes.machine =
    { ... }:

    {
      programs.nvbroadcast = {
        enable = true;
        nvidia.enable = false;
        pipewire.enable = false;
        v4l2loopback.enable = false;
      };

      environment.variables.NVBROADCAST_SKIP_REQUIREMENTS_CHECK = "1";
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("test -x /run/current-system/sw/bin/nvbroadcast")
    machine.succeed("nvbroadcast --help")
    machine.succeed("nvbroadcast-vcam --help")
  '';
}
