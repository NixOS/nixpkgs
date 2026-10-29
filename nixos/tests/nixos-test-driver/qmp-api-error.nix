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
        t.assertEqual(error.class_name, "CommandNotFound")
        t.assertTrue(error.description)
        t.assertIsNone(error.transaction_id)
    else:
        raise AssertionError("expected QMPAPIError")
  '';
}
