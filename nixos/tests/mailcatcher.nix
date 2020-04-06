import ./make-test-python.nix ({ lib, ... }:

{
  name = "mailcatcher";
  meta.maintainers = [ lib.maintainers.aanderse ];

  machine =
    { pkgs, ... }:
    {
      services.mailcatcher.enable = true;

      services.ssmtp.enable = true;
      services.ssmtp.hostName = "localhost:1025";

      environment.systemPackages = [ pkgs.mailutils ];
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("mailcatcher.service")
    machine.wait_for_open_port("1025")
    machine.succeed(
        'echo "this is the body of the email" | mail -s "subject" root@example.org'
    )
    assert "this is the body of the email" in machine.succeed(
        "curl http://localhost:1080/messages/1.source"
    )
  '';
})
