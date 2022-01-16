machine.wait_for_unit("multi-user.target")

with subtest("require_unit_state"):
    with subtest("success"):
        machine.require_unit_state("multi-user.target", "active")
    with subtest("failure"), must_raise("to to be in state 'borked'"):
        machine.require_unit_state("multi-user.target", "borked")
