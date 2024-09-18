import ./make-test-python.nix ({ lib, ... }: {
  name = "archi";
  meta.maintainers = with lib.maintainers; [ paumr ];

  nodes.machine = { pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    environment.systemPackages = with pkgs; [ archi ];
  };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    with subtest("createEmptyModel via CLI"):
         machine.succeed("Archi -application com.archimatetool.commandline.app -consoleLog -nosplash --createEmptyModel --saveModel smoke.archimate")
         machine.copy_from_vm("smoke.archimate", "")

    with subtest("UI smoketest"):
         machine.succeed("DISPLAY=:0 Archi --createEmptyModel >&2 &")
         machine.wait_for_window("Archi")

         # wait till main UI is open
         # since OCR seems to be buggy wait_for_text was replaced by sleep, issue: #302965
         # machine.wait_for_text("Welcome to Archi")
         machine.sleep(20)

         machine.screenshot("welcome-screen")
  '';
})
