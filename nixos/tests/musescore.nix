import ./make-test-python.nix ({ pkgs, ...} :

let
  # Make sure we don't have to go through the startup tutorial
  customMuseScoreConfig = pkgs.writeText "MuseScore3.ini" ''
    [application]
    startup\firstStart=false

    [ui]
    application\startup\showTours=false
    application\startup\showStartCenter=false
    '';
in
{
  name = "musescore";
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
      musescore
      pdfgrep
    ];
  };

  enableOCR = true;

  testScript = { ... }: ''
    start_all()
    machine.wait_for_x()

    # Inject custom settings
    machine.succeed("mkdir -p /root/.config/MuseScore/")
    machine.succeed(
        "cp ${customMuseScoreConfig} /root/.config/MuseScore/MuseScore3.ini"
    )

    # Start MuseScore window
    machine.execute("DISPLAY=:0.0 mscore >&2 &")

    # Wait until MuseScore has launched
    machine.wait_for_window("MuseScore")

    # Wait until the window has completely initialised
    machine.wait_for_text("MuseScore")

    # Start entering notes
    machine.send_key("n")
    # Type the beginning of https://de.wikipedia.org/wiki/Alle_meine_Entchen
    machine.send_chars("cdef6gg5aaaa7g")
    # Make sure the VM catches up with all the keys
    machine.sleep(1)

    machine.screenshot("MuseScore0")

    # Go to the export dialogue and create a PDF
    machine.send_key("alt-f")
    machine.sleep(1)
    machine.send_key("e")

    # Wait until the export dialogue appears.
    machine.wait_for_window("Export")
    machine.screenshot("MuseScore1")
    machine.send_key("ret")
    machine.sleep(1)
    machine.send_key("ret")

    machine.screenshot("MuseScore2")

    # Wait until PDF is exported
    machine.wait_for_file("/root/Documents/MuseScore3/Scores/Untitled.pdf")

    # Check that it contains the title of the score
    machine.succeed("pdfgrep Title /root/Documents/MuseScore3/Scores/Untitled.pdf")

    machine.screenshot("MuseScore3")
  '';
})
