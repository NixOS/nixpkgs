{ pkgs, ... }:
{
  name = "sdl3";
  meta.maintainers = pkgs.sdl3.meta.maintainers;

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      environment.systemPackages = [ pkgs.sdl3.passthru.debug-text-example ];
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    machine.execute("debug-text >&2 &")

    machine.wait_for_window("examples/renderer/debug-text")
    machine.wait_for_text("Hello world")

    machine.screenshot("screen")
  '';
}
