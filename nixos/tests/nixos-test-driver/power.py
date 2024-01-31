with subtest("power off related"):
    for method in [machine.shutdown, machine.crash]:
        with subtest(method.__name__):
            machine.wait_for_unit("multi-user.target")
            method()
            machine.wait_for_shutdown()
            assert not machine.booted
            # No-op, but shouldn't throw an error:
            method()
            join_all()
            # Re-start the machine:
