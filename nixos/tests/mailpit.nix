{ lib, ... }:
{
  name = "mailpit";
  meta.maintainers = lib.teams.flyingcircus.members;

  nodes.machine =
    { pkgs, ... }:
    {
      services.mailpit.instances.default = { };

      environment.systemPackages = with pkgs; [ swaks ];
    };

  testScript = ''
    start_all()

    from json import loads

    machine.wait_for_unit("mailpit-default.service")
    machine.wait_for_open_port(1025)
    machine.wait_for_open_port(8025)
    machine.succeed(
        'echo "this is the body of the email" | swaks --to root@example.org --body - --server localhost:1025'
    )

    received = loads(machine.succeed("curl http://localhost:8025/api/v1/messages"))
    assert received['total'] == 1
    message = received["messages"][0]
    assert len(message['To']) == 1
    assert message['To'][0]['Address'] == 'root@example.org'
    assert "this is the body of the email" in message['Snippet']
  '';
}
