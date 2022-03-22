machine.wait_for_unit("multi-user.target")

with subtest("require_unit_state"):
    machine.require_unit_state("multi-user.target", "active")
    with must_raise("to to be in state 'borked'"):
        machine.require_unit_state("multi-user.target", "borked")
