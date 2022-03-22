machine.wait_for_x()
machine.succeed("xterm >&2 &")
machine.wait_for_text("root@", timeout=10)
# assert "root@" in machine.get_screen_text_variants()
