{ hostPkgs, lib, ... }:
{
  name = "zoom-us";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];
      programs.zoom-us.enable = true;
    };

  testScript = ''
    machine.succeed("which zoom")  # fail early if this is missing
    machine.wait_for_x()
    machine.execute("zoom >&2 &")
    machine.wait_for_window("Zoom Workplace")
  '';
}
