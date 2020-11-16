# Terminal emulators all present a pretty similar interface.
# That gives us an opportunity to easily test their basic functionality with a single codebase.
#
# There are two tests run on each terminal emulator
# - can it successfully execute a command passed on the cmdline?
# - can it successfully display a colour?
# the latter is used as a proxy for "can it display text?", without going through all the intricacies of OCR.
#
# 256-colour terminal mode is used to display the test colour, since it has a universally-applicable palette (unlike 8- and 16- colour, where the colours are implementation-defined), and it is widely supported (unlike 24-bit colour).
#
# Future work:
# - Wayland support (both for testing the existing terminals, and for testing wayland-only terminals like foot and havoc)
# - Test keyboard input? (skipped for now, to eliminate the possibility of race conditions and focus issues)

{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let tests = {
      alacritty.cmd = pkgs: "${pkgs.alacritty}/bin/alacritty -e $1";

      cool-retro-term.cmd = pkgs: "${pkgs.cool-retro-term}/bin/cool-retro-term -e $1";
      cool-retro-term.colourTest = false; # Post-processing would break it

      eterm.cmd = pkgs: "${pkgs.eterm}/bin/Eterm -e $1";
      eterm.pinkValue = "#D40055"; # darkened, for some reason

      gnome-terminal.cmd = pkgs: "${pkgs.gnome3.gnome-terminal}/bin/gnome-terminal -- $1";

      kitty.cmd = pkgs: "${pkgs.kitty}/bin/kitty $1";

      konsole.cmd = pkgs: "${pkgs.konsole}/bin/konsole -e $1";

      lxterminal.cmd = pkgs: "${pkgs.lxterminal}/bin/lxterminal -e $1";

      mlterm.cmd = pkgs: "${pkgs.mlterm}/bin/mlterm -e $1";

      mrxvt.cmd = pkgs: "${pkgs.mrxvt}/bin/mrxvt -e $1";

      roxterm.cmd = pkgs: "${pkgs.roxterm}/bin/roxterm -e $1";

      sakura.cmd = pkgs: "${pkgs.sakura}/bin/sakura -e $1";

      stupidterm.cmd = pkgs: "${pkgs.stupidterm}/bin/stupidterm -- $1";

      terminator.cmd = pkgs: "${pkgs.terminator}/bin/terminator -e $1";

      terminology.cmd = pkgs: "${pkgs.enlightenment.terminology}/bin/terminology --no-wizard=true -e $1";
      terminology.colourTest = false; # gloss effect breaks it

      termite.cmd = pkgs: "${pkgs.termite}/bin/termite -e $1";

      urxvt.cmd = pkgs: "${pkgs.rxvt_unicode}/bin/urxvt -e $1";

      wayst.cmd = pkgs: "${pkgs.wayst}/bin/wayst -e $1";
      wayst.pinkValue = "#FF0066"; # wayst gets the blue channel too dark for some reason

      xfce4-terminal.cmd = pkgs: "${pkgs.xfce.terminal}/bin/xfce4-terminal -e $1";

      xterm.cmd = pkgs: "${pkgs.xterm}/bin/xterm -e $1";
    };
in mapAttrs (name: { cmd, colourTest ? true, pinkValue ? "#FF0087" }: makeTest
{
  name = "terminal-emulator-${name}";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ jjjollyjim ];
  };

  machine = { pkgs, ... }:

  {
    imports = [ ./common/x11.nix ];

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "report-success" ''
        echo 1 > /tmp/term-ran-successfully
      '')
      (pkgs.writeShellScriptBin "display-colour" ''
        # A 256-colour background colour code for pink, then spaces.
        # Background is used rather than foreground to minimize the effect of anti-aliasing.
        echo -e "\e[48;5;198m                   "
        sleep infinity
      '')
      (pkgs.writeShellScriptBin "run-in-this-term" (cmd pkgs))
    ];
  };

  # We need imagemagick, though not tesseract
  enableOCR = true;

  testScript = { nodes, ... }: let
  in ''
    with subtest("wait for x"):
        start_all()
        machine.wait_for_x()

    with subtest("have the terminal run a command"):
        # We run this command synchronously, so we can be certain the exit codes are happy
        machine.succeed("run-in-this-term report-success")
        machine.wait_for_file("/tmp/term-ran-successfully")
    ${optionalString colourTest ''


    def check_for_pink(final=False) -> bool:
        with tempfile.NamedTemporaryFile() as tmpin:
            machine.send_monitor_command("screendump {}".format(tmpin.name))

            cmd = 'convert {} -define histogram:unique-colors=true -format "%c" histogram:info:'.format(
                tmpin.name
            )
            ret = subprocess.run(cmd, shell=True, capture_output=True)
            if ret.returncode != 0:
                raise Exception(
                    "image analysis failed with exit code {}".format(ret.returncode)
                )

            text = ret.stdout.decode("utf-8")
            return "${pinkValue}" in text


    with subtest("ensuring no pink is present without the terminal"):
        assert (
            check_for_pink() == False
        ), "Pink was present on the screen before we even launched a terminal!"

    with subtest("have the terminal display a colour"):
        # We run this command in the background
        machine.succeed("run-in-this-term display-colour &")

        with machine.nested("Waiting for the screen to have pink on it:"):
            retry(check_for_pink)
  ''}'';
}

  ) tests
