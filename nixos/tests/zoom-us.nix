{ hostPkgs, lib, ... }:
{
  name = "zoom-us";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];
      programs.zoom-us.enable = true;
    };

  testScript = ''
    import time

    machine.succeed("which zoom")  # fail early if this is missing
    machine.wait_for_x()
    machine.execute("zoom > /tmp/zoom-us.log 2>&1 & echo $! > /tmp/zoom-us.pid")

    def has_zoom_window():
        return any("Zoom Workplace" in name for name in machine.get_window_names())

    # Zoom should open its main window shortly after startup. Poll for it, but
    # stop as soon as the launcher process exits (for example because of a
    # missing shared library) instead of waiting for the whole window timeout.
    deadline = time.time() + 120
    while not has_zoom_window():
        if machine.execute("kill -0 $(cat /tmp/zoom-us.pid)")[0] != 0:
            raise Exception(
                "zoom exited before opening its main window:\n"
                + machine.execute("cat /tmp/zoom-us.log")[1]
            )
        if time.time() > deadline:
            raise Exception(
                "timed out waiting for the Zoom Workplace window:\n"
                + machine.execute("cat /tmp/zoom-us.log")[1]
            )
        time.sleep(1)

    # The window should stay open for a while instead of crashing on startup.
    machine.sleep(20)
    if not has_zoom_window():
        raise Exception(
            "the Zoom Workplace window disappeared shortly after startup:\n"
            + machine.execute("cat /tmp/zoom-us.log")[1]
        )
  '';
}
