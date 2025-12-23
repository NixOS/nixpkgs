{ pkgs, lib, ... }:
{
  name = "shadps4-openorbis-example";
  meta = {
    inherit (pkgs.shadps4.meta) maintainers;
  };

  nodes.machine =
    { pkgs, ... }:
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
              nativeBuildInputs = with pkgs; [
                unzip
                liborbispkg-pkgtool
              ];
              meta.license = lib.licenses.gpl3Only;
            }
            ''
              unzip ${sample-packages} samples/IV0000-BREW00086_00-IPNGDRAWEX000000.pkg
              mkdir -p $out/OpenOrbis-PNG-Sample
              pkgtool pkg_extract samples/IV0000-BREW00086_00-IPNGDRAWEX000000.pkg $out/OpenOrbis-PNG-Sample
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

      virtualisation.memorySize = 2048;
    };

  enableOCR = true;

  testScript = ''
    from collections.abc import Callable
    import tempfile
    import subprocess

    selectionColor: str = "#354953"
    openorbisColor: str = "#306082"

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

    with subtest("running example works"):
        # Ensure that chosen openorbis logo colour isn't present already
        assert (
            check_for_color(openorbisColor)(True) == False
        ), "openorbisColor {} was present on the screen before we launched anything!".format(openorbisColor)

        machine.succeed("shadps4 /etc/openorbis-sample-packages/OpenOrbis-PNG-Sample/uroot/eboot.bin >&2 &")

        # Look for logo
        with machine.nested("Waiting for the screen to have openorbisColor {} on it:".format(openorbisColor)):
            retry(check_for_color(openorbisColor))
        machine.screenshot("0001-shadps4-sample-running")
  '';
}
