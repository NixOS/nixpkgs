{ pkgs, lib, ... }:
{
  name = "shadps4-openorbis-example";
  meta = {
    inherit (pkgs.shadps4.meta) maintainers;
    platforms = lib.intersectLists lib.platforms.linux pkgs.shadps4.meta.platforms;
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      environment = {
        # Samples from the OpenOrbis PS4 homebrew toolchain, gpl3Only
        etc."openorbis-sample-packages".source =
          let
            sample-packages = pkgs.fetchurl {
              url = "https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain/releases/download/v0.5.2/sample-packages.zip";
              hash = "sha256-aWocIVpyMivA1vsUe9w97J3eMFANyXxyVLBxHGXIcEA=";
            };
          in
          pkgs.runCommand "OpenOrbis-PNG-Sample"
            {
              nativeBuildInputs = with pkgs; [ unzip ];
              meta.license = lib.licenses.gpl3Only;
            }
            ''
              unzip ${sample-packages} samples/IV0000-BREW00086_00-IPNGDRAWEX000000.pkg
              mkdir $out
              mv samples/IV0000-BREW00086_00-IPNGDRAWEX000000.pkg $out/OpenOrbis-PNG-Sample.pkg
            '';

        systemPackages = with pkgs; [
          imagemagick # looking for colour on screen
          shadps4
          xdotool # move mouse
        ];

        variables = {
          # Emulated CPU doesn't support invariant TSC
          TRACY_NO_INVARIANT_CHECK = "1";
        };
      };
    };

  enableOCR = true;

  testScript = ''
    from collections.abc import Callable
    import tempfile
    import subprocess

    selectionColor: str = "#2A82DA"
    openorbisColor: str = "#336081"

    # Based on terminal-emulators.nix' check_for_pink
    def check_for_color(color: str) -> Callable[[bool], bool]:
        def check_for_color_retry(final=False) -> bool:
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
                return color in text

        return check_for_color_retry

    machine.wait_for_x()

    with subtest("starting shadps4 works"):
        machine.succeed("shadps4 >&2 &")
        machine.wait_for_text("Directory to install games")
        machine.screenshot("0001-shadps4-dir-setup-prompt")

        machine.send_chars("/root\n")
        machine.wait_for_text("Game List")
        # Make it fullscreen, so mouse coords are simpler & content isn't cut off
        machine.send_key("alt-f10")
        # Should now see the rest too
        machine.wait_for_text("Play Time")
        machine.screenshot("0002-shadps4-started")

    with subtest("installing example works"):
        machine.succeed("xdotool mousemove 20 30 click 1") # click on "File"
        machine.wait_for_text("Install Packages")
        machine.send_key("down")
        machine.send_key("ret")

        # Pick the PNG sample (hello world runs too, but text-only output is currently broken)
        machine.wait_for_text("Look in")
        machine.send_chars("/etc/openorbis-sample-packages/OpenOrbis-PNG-Sample.pkg\n")

        # Install to default dir
        machine.wait_for_text("which directory")
        machine.send_key("ret")

        # Wait for installation getting done & return to main window
        machine.wait_for_text("successfully installed")
        machine.send_key("ret")

        # Sample should now be listed
        machine.wait_for_text("OpenOrbis PNG Sample")
        machine.screenshot("0003-shadps4-sample-installed")

    with subtest("emulation works-ish"):
        # Ensure that selection colours isn't present already
        assert (
            check_for_color(selectionColor)(True) == False
        ), "selectionColor {} was present on the screen before we selected anything!".format(selectionColor)

        # Select first installed app
        machine.succeed("xdotool mousemove 20 150 click 1")

        # Waiting for selection to be confirmed
        with machine.nested("Waiting for the screen to have selectionColor {} on it:".format(selectionColor)):
            retry(check_for_color(selectionColor))

        # Ensure that chosen openorbis logo colour isn't present already
        assert (
            check_for_color(openorbisColor)(True) == False
        ), "openorbisColor {} was present on the screen before we selected anything!".format(openorbisColor)

        # Click launch button
        machine.succeed("xdotool mousemove 40 60 click 1")
        machine.wait_for_console_text("Entering draw loop...")

        # Look for logo
        with machine.nested("Waiting for the screen to have openorbisColor {} on it:".format(openorbisColor)):
            retry(check_for_color(openorbisColor))
        machine.screenshot("0004-shadps4-sample-running")
  '';
}
