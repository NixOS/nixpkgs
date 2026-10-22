{
  config,
  hostPkgs,
  lib,
  ...
}:
let
  # This test script loads the nested driver's configuration.
  # Give that driver an empty script to avoid a circular store reference.
  interactiveConfig = hostPkgs.writers.writeJSON "interactive-driver-config.json" (
    config.interactive.driverConfiguration // { test_script = hostPkgs.emptyFile; }
  );
in
{
  name = "nspawn-interactive";
  meta.teams = [ lib.teams.test-driver ];

  containers.machine = {
    imports = [ ../common/x11.nix ];
    virtualisation.vlans = [ ];
  };

  # Run a nested interactive driver under Xvfb, type into the container through
  # TigerVNC, and check that closing the viewer leaves the container running.
  testScript = ''
    import datetime as dt
    import os
    import subprocess
    from collections.abc import Generator
    from contextlib import contextmanager

    from test_driver.driver import Driver, load_driver_configuration

    def xdotool(*args: str) -> str:
        return subprocess.check_output(
            ["${lib.getExe hostPkgs.xdotool}", *args], text=True, timeout=30
        ).strip()

    def wait_for_host_display() -> None:
        def can_connect(_last_try: bool) -> bool:
            return subprocess.call(
                ["${lib.getExe hostPkgs.xdotool}", "getdisplaygeometry"],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            ) == 0

        retry(can_connect, timeout=dt.timedelta(seconds=30))

    def wait_for_viewer() -> str:
        return xdotool(
            "search", "--sync", "--onlyvisible", "--name",
            r"machine \(nspawn\)",
        )

    def open_guest_terminal(machine: NspawnMachine) -> None:
        # Keep the shell prompt from replacing the terminal's window title.
        machine.execute("xterm -title input-test -e bash --noprofile --norc >&2 &")
        machine.wait_for_window("input-test", timeout=dt.timedelta(seconds=30))

    def focus_terminal_in_viewer(machine: NspawnMachine, window: str) -> None:
        xdotool("windowraise", window)
        xdotool("windowfocus", "--sync", window)
        xdotool("mousemove", "--window", window, "150", "200")
        xdotool("click", "1")

        machine.wait_until_succeeds(
            'test "$(xdotool getwindowfocus getwindowname)" = input-test',
            timeout=dt.timedelta(seconds=30),
        )

    def run_command_in_terminal(
        machine: NspawnMachine, window: str, command: str
    ) -> None:
        focus_terminal_in_viewer(machine, window)
        xdotool("type", "--delay", "50", command)
        xdotool("key", "Return")

    @contextmanager
    def test_display() -> Generator[None]:
        # Keep the viewer visible while debugging the outer test interactively.
        if driver.interactive and os.environ.get("DISPLAY"):
            yield
            return

        previous_display = os.environ.get("DISPLAY")
        with subprocess.Popen([
            "${lib.getExe' hostPkgs.xorg-server "Xvfb"}", ":99", "-screen", "0", "1280x1024x24", "-ac",
        ]) as display:
            os.environ["DISPLAY"] = ":99"
            try:
                yield
            finally:
                display.terminate()
                if previous_display is None:
                    os.environ.pop("DISPLAY", None)
                else:
                    os.environ["DISPLAY"] = previous_display

    with test_display():
        wait_for_host_display()

        with Driver(
            config=load_driver_configuration("${interactiveConfig}"),
            out_dir=driver.out_dir,
            logger=driver.logger,
            interactive=True,
        ) as interactive:
            machine = interactive.machines_nspawn[0]
            machine.start()

            with subtest("type through the viewer"):
                window = wait_for_viewer()
                machine.fail("ss -H -lntp | grep -w x11vnc")
                open_guest_terminal(machine)
                run_command_in_terminal(machine, window, "echo viewer-input > /tmp/viewer-input")
                machine.wait_until_succeeds(
                    "grep -qx viewer-input /tmp/viewer-input",
                    timeout=dt.timedelta(seconds=30),
                )

            with subtest("closing the viewer leaves the container running"):
                xdotool("windowclose", window)
                machine.wait_until_fails("pgrep -x x11vnc")
                machine.succeed("test -s /tmp/viewer-input")
  '';
}
