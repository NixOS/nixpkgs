import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "kdenlive";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ turion ];
  };

  nodes.machine = { ... }:

  {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    environment.systemPackages = with pkgs; [
      kdenlive
    ];
  };

  enableOCR = true;

  testScript = { ... }: ''
    start_all()
    machine.wait_for_x()

    # Start Kdenlive window
    machine.execute("env XDG_RUNTIME_DIR=$PWD DISPLAY=:0.0 kdenlive >&2 &")

    # Wait until Welcome Window has launched
    machine.wait_for_window("Welcome to Kdenlive")

    machine.screenshot("Kdenlive1")

    # Press ok
    machine.send_key("ret")

    # Wait until Kdenlive main window has launched
    machine.wait_for_window("Untitled")

    machine.screenshot("Kdenlive2")
  '';
})
