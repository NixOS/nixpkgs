import ./make-test-python.nix ({ pkgs, ...} :
{
  name = "sgtpuzzles";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ tomfitzhenry ];
  };

  nodes.machine = { ... }:

  {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    environment.systemPackages = with pkgs; [
      sgtpuzzles
    ];
  };

  enableOCR = true;

  testScript = { nodes, ... }:
  ''
    start_all()
    machine.wait_for_x()

    machine.execute("mines >&2 &")

    machine.wait_for_window("Mines")
    machine.wait_for_text("Marked")
    machine.screenshot("mines")
  '';
})
