from test_driver.machine import retry

with subtest("retry"):
    # Should not throw, because we are saving it in the last go.
    with must_raise("action timed out"), no_sleep():
        retry(lambda x: False)
    with no_sleep():
        retry(lambda x: x)

with subtest("low-level commands"):
    with subtest("execute"):
        assert machine.execute("true") == (0, "")
        assert machine.execute("false", check_return=False) == (-1, "")

    with subtest("succeed"):
        r = machine.succeed("echo hello")
        assert r == "hello\n"
        machine.wait_until_succeeds("true")
        with must_raise("command `false` failed"):
            machine.succeed("false")
    with subtest("fail"):
        machine.fail("false")
        machine.wait_until_fails("false")
        with must_raise("command `true` unexpectedly succeeded"):
            machine.fail("true")

    assert machine.is_up()
    machine.sleep(2)

# Not sure where this should go - we explicitly need OCR off so it can't go in
# the OCR test.:
with must_raise("OCR requested but enableOCR is false"):
    machine.wait_for_text("foobar")

with subtest("send_monitor_command"):
    r = machine.send_monitor_command("help")

    # for both of these to succeed we need to grab >10kb of data,
    # which ensures chunking is working as expected
    assert "balloon" in r  # The first output
    assert "(qemu)" in r  # The last output
