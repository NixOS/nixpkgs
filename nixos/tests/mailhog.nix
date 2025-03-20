import ./make-test-python.nix ({lib, ...}: {
  name = "mailhog";
  meta.maintainers = with lib.maintainers; [jojosch RTUnreal];

  nodes.machine = {pkgs, ...}: {
    services.mailhog.enable = true;
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("mailhog.service")
    machine.wait_for_open_port(1025)
    machine.wait_for_open_port(8025)
    # Test sendmail wrapper (this uses smtp, which tests the connection)
    machine.succeed('printf "To: root@example.com\r\n\r\nthis is the body of the email" | sendmail -t -i -f sender@example.com')
    res = machine.succeed(
        "curl --fail http://localhost:8025/api/v2/messages"
    )
    assert all(msg in res for msg in ["this is the body of the email", "sender@example.com", "root@example.com"])
  '';
})
