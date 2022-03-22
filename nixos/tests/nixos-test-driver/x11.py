out = driver.out_dir

with subtest("wait_for_x"):
    machine.wait_for_x()
    machine.sleep(3)


with subtest("wait_for_window"):
    with subtest("failure"), no_sleep(), must_raise("action timed out"):
        machine.wait_for_window("foobar", timeout=10)

    with subtest("success"):
        machine.succeed("xterm >&2 &")
        machine.sleep(3)
        machine.wait_for_window("xterm")

with subtest("get_window_names"):
    assert "xterm" in machine.get_window_names()


with subtest("screenshot"):
    machine.screenshot("foo")
    assert (out / "foo.png").exists()
    machine.screenshot("/tmp/bar.png")
    assert Path("/tmp/bar.png").exists()
