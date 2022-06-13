import ./make-test-python.nix ({ pkgs, lib, ... }:

{
  name = "angband";
  meta = { maintainers = with lib.maintainers; [ kenran ]; };

  nodes.machine = { pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    environment.systemPackages =
      [ pkgs.angband pkgs.xterm pkgs.source-code-pro ];
  };

  enableOCR = true;

  testScript = let angbandSdl2 = pkgs.angband.override { enableSdl2 = true; };
  in ''
    machine.start()
    machine.wait_for_x()

    # xterm instance from which we launch the game
    machine.succeed("DISPLAY=:0 xterm -fa 'Source Code Pro' -fs 13 -fullscreen >&2 &")
    machine.sleep(2)

    with subtest("Can run Angband with GCU frontend"):
        machine.send_chars("angband -mgcu\n")
        # Angband has started
        machine.wait_for_text("Initialization complete")
        machine.screenshot("gcu_angband")

        machine.send_chars("x")
        machine.sleep(1)
        machine.send_key("ctrl-x")

    machine.sleep(2)

    with subtest("Can run Angband with SDL2 frontend"):
        machine.send_chars("${lib.getExe angbandSdl2} -g -msdl2\n")
        machine.wait_for_window("Angband")
        machine.screenshot("sdl2_angband")
  '';
})
