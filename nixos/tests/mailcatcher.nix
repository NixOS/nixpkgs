{ lib, ... }:

{
  name = "mailcatcher";
  meta.maintainers = [ lib.maintainers.aanderse ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.mailcatcher.enable = true;

      programs.msmtp = {
        enable = true;
        accounts.default = {
          host = "localhost";
          port = 1025;
        };
      };

      environment.systemPackages = [ pkgs.mailutils ];
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("mailcatcher.service")
    machine.wait_for_open_port(1025)
    machine.succeed(
        'echo "this is the body of the email" | mail -s "subject" root@example.org'
    )
    assert "this is the body of the email" in machine.succeed(
        "curl -f http://localhost:1080/messages/1.source"
    )
  '';
}
