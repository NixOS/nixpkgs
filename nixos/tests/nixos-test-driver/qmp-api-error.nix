{
  name = "qmp-api-error";

  nodes.machine = { };

  testScript = ''
    from test_driver.machine.qmp import QMPAPIError

    machine.start()

    assert machine.qmp_client is not None

    try:
        machine.qmp_client.send("this-command-does-not-exist")
    except QMPAPIError as error:
        assert error.class_name == "CommandNotFound"
        assert error.description
        assert error.transaction_id is None
    else:
        raise AssertionError("expected QMPAPIError")
  '';
}
