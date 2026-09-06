import os
import platform


def graphical_display_available() -> bool:
    if platform.system() == "Darwin":
        # We have no DISPLAY variables on macOS and seemingly no better way
        # to find out.
        return "TERM_PROGRAM" in os.environ

    return any(name in os.environ for name in ("DISPLAY", "WAYLAND_DISPLAY"))
