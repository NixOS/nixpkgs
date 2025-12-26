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

{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  tests = {
    alacritty.pkg = p: p.alacritty;

    contour.pkg = p: p.contour;
    contour.cmd = "contour early-exit-threshold 0 execute $command";

    cool-retro-term.pkg = p: p.cool-retro-term;
    cool-retro-term.colourTest = false; # broken by gloss effect

    ctx.pkg = p: p.ctx;
    ctx.pinkValue = "#FE0065";

    darktile.pkg = p: p.darktile;

    germinal.pkg = p: p.germinal;

    ghostty.pkg = p: p.ghostty;

    gnome-terminal.pkg = p: p.gnome-terminal;

    guake.pkg = p: p.guake;
    guake.cmd = "SHELL=$command guake --show";
    guake.kill = true;

    hyper.pkg = p: p.hyper;

    kermit.pkg = p: p.kermit-terminal;

    kgx.pkg = p: p.kgx;
    kgx.cmd = "kgx -e $command";
    kgx.kill = true;

    kitty.pkg = p: p.kitty;
    kitty.cmd = "kitty $command";

    konsole.pkg = p: p.kdePackages.konsole;

    lxterminal.pkg = p: p.lxterminal;

    mate-terminal.pkg = p: p.mate.mate-terminal;
    mate-terminal.cmd = "SHELL=$command mate-terminal --disable-factory"; # factory mode uses dbus, and we don't have a proper dbus session set up

    mlterm.pkg = p: p.mlterm;
    mlterm.kill = true;

    qterminal.pkg = p: p.lxqt.qterminal;
    qterminal.kill = true;

    rio.pkg = p: p.rio;
    rio.cmd = "rio -e $command";
    rio.colourTest = false; # the rendering is changing too much so colors change every release.

    roxterm.pkg = p: p.roxterm;
    roxterm.cmd = "roxterm -e $command";

    sakura.pkg = p: p.sakura;

    st.pkg = p: p.st;
    st.kill = true;

    stupidterm.pkg = p: p.stupidterm;
    stupidterm.cmd = "stupidterm -- $command";

    terminator.pkg = p: p.terminator;
    terminator.cmd = "terminator -e $command";

    terminology.pkg = p: p.enlightenment.terminology;
    terminology.cmd = "SHELL=$command terminology --no-wizard=true";
    terminology.colourTest = false; # broken by gloss effect

    termite.pkg = p: p.termite;

    termonad.pkg = p: p.termonad;

    tilda.pkg = p: p.tilda;

    tilix.pkg = p: p.tilix;
    tilix.cmd = "tilix -e $command";

    urxvt.pkg = p: p.rxvt-unicode;

    wayst.pkg = p: p.wayst;
    wayst.pinkValue = "#FF0066";

    # times out after spending many hours
    #wezterm.pkg = p: p.wezterm;

    xfce4-terminal.pkg = p: p.xfce.xfce4-terminal;

    xterm.pkg = p: p.xterm;

    zutty.pkg = p: p.zutty;
  };
in
mapAttrs (
  name:
  {
    pkg,
    executable ? name,
    cmd ? "SHELL=$command ${executable}",
    colourTest ? true,
    pinkValue ? "#FF0087",
    kill ? false,
  }:
  makeTest {
    name = "terminal-emulator-${name}";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ jjjollyjim ];
    };

    nodes.machine =
      { pkgsInner, ... }:

      {
        imports = [
          ./common/x11.nix
          ./common/user-account.nix
        ];

        # Hyper (and any other electron-based terminals) won't run as root
        test-support.displayManager.auto.user = "alice";

        environment.systemPackages = [
          (pkg pkgs)
          (pkgs.writeShellScriptBin "report-success" ''
            echo 1 > /tmp/term-ran-successfully
            ${optionalString kill "pkill ${executable}"}
          '')
          (pkgs.writeShellScriptBin "display-colour" ''
            # A 256-colour background colour code for pink, then spaces.
            #
            # Background is used rather than foreground to minimize the effect of anti-aliasing.
            #
            # Keep adding more in case the window is partially offscreen to the left or requires
            # a change to correctly redraw after initialising the window (as with ctx).

            while :
            do
                echo -ne "\e[48;5;198m                   "
                sleep 0.5
            done
            sleep infinity
          '')
          (pkgs.writeShellScriptBin "run-in-this-term" "sudo -u alice run-in-this-term-wrapped $1")

          (pkgs.writeShellScriptBin "run-in-this-term-wrapped" "command=\"$(which \"$1\")\"; ${cmd}")
        ];

        # Helpful reminder to add this test to passthru.tests
        warnings =
          if !((pkg pkgs) ? "passthru" && (pkg pkgs).passthru ? "tests") then
            [ "The package for ${name} doesn't have a passthru.tests" ]
          else
            [ ];
      };

    # We need imagemagick, though not tesseract
    enableOCR = true;

    testScript =
      { nodes, ... }:
      let
      in
      ''
        with subtest("wait for x"):
            start_all()
            machine.wait_for_x()

        with subtest("have the terminal run a command"):
            # We run this command synchronously, so we can be certain the exit codes are happy
            machine.${if kill then "execute" else "succeed"}("run-in-this-term report-success")
            machine.wait_for_file("/tmp/term-ran-successfully")
        ${optionalString colourTest ''

          import tempfile
          import subprocess


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
              assert machine.shell is not None
              machine.shell.send(b"(run-in-this-term display-colour |& systemd-cat -t terminal) &\n")

              with machine.nested("Waiting for the screen to have pink on it:"):
                  retry(check_for_pink)
        ''}'';
  }

) tests
