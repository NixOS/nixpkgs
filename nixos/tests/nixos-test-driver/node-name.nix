{
  name = "nixos-test-driver.node-name";
  nodes = {
    "ok" = { };

    # Valid node name, but not a great host name.
    "one_two" = { };

    # Valid node name, good host name
    "a-b" = { };

    # TODO: would be nice to test these eval failures
    # Not allowed by lib/testing/network.nix (yet?)
    # "foo.bar" = { };
    # Not allowed.
    # "not ok" = { }; # not ok
  };

  testScript = ''
    start_all()

    with subtest("python vars exist and machines are reachable through test backdoor"):
      ok.succeed("true")
      one_two.succeed("true")
      a_b.succeed("true")

    with subtest("hostname is derived from the node name"):
      ok.succeed("hostname | tee /dev/stderr | grep '^ok$'")
      one_two.succeed("hostname | tee /dev/stderr | grep '^onetwo$'")
      a_b.succeed("hostname | tee /dev/stderr | grep '^a-b$'")

  '';
}
