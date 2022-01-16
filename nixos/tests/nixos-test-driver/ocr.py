machine.wait_for_x()
machine.succeed("xterm >&2 &")

with subtest("wait_for_text"):
    with subtest("success"):
        machine.wait_for_text("root@", timeout=10)
    with subtest("failure"), no_sleep(), must_raise("timed out"):
        machine.wait_for_text("It never comes", timeout=10)

assert any("root@" in t for t in machine.get_screen_text_variants())
