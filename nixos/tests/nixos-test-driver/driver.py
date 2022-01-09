with subtest("subtest"):
    with must_raise("", SystemExit):
        # Logger.error uses sys.exit. TODO: is this what we want?
        with subtest("foobar"):
            raise Exception("Oops.")
