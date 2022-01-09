with subtest("polling_condition"):

    with subtest("Failures"):

        @polling_condition
        def polling_condition_always_false():
            return False

        @polling_condition
        def polling_condition_raises():
            machine.succeed("false")

        for condition in [polling_condition_always_false, polling_condition_raises]:
            with must_raise(
                f"Polling condition failed: {condition.condition.description}"
            ):
                with condition:
                    machine.succeed("true")

    with subtest("Successes"):

        @polling_condition
        def polling_condition_simple():
            machine.succeed("true")

        @polling_condition
        def polling_condition_always_true():
            return True

        genericDescription = "This is a description"

        @polling_condition(description=genericDescription)
        def polling_condition_explicit_description():
            pass

        @polling_condition
        def polling_condition_docstring_description():
            "This is a description"
            pass

        assert (
            polling_condition_explicit_description.condition.description
            == genericDescription
        )

        assert (
            polling_condition_docstring_description.condition.description
            == genericDescription
        )

        for condition in [
            polling_condition_simple,
            polling_condition_always_true,
            polling_condition_explicit_description,
            polling_condition_docstring_description,
        ]:
            with condition:
                machine.succeed("true")
