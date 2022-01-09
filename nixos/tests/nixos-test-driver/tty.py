import string
import re

test_string = "".join(c for c in string.printable if c not in string.whitespace)

with subtest("wait_until_tty_matches"):
    with subtest("success"):
        machine.wait_until_tty_matches(1, "root@")

    with subtest("failure"), no_sleep(), must_raise("action timed out"):
        machine.wait_until_tty_matches(1, "asdfasdf", timeout=10)

with subtest("send_chars"):
    machine.send_chars("cat\n")
    machine.sleep(2)
    machine.send_chars(test_string + "\n")
    machine.wait_until_tty_matches(1, re.escape(test_string), timeout=10)
    machine.send_key("ctrl-d")

with subtest("wait_for_console_text"):
    with subtest("failure"), no_sleep(), must_raise("action timed out"):
        machine.wait_for_console_text("foobar", timeout=10)

#     with subtest("success"):
#         machine.send_chars("sleep 10; echo foobar | systemd-cat\n")
#         machine.wait_for_console_text("foobar")
