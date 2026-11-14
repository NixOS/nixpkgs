{ pkgs, lib, ... }:
{
  name = "gotify-server";
  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.jq ];

      services.gotify = {
        enable = true;
        environment = {
          GOTIFY_SERVER_PORT = 3000;
        };
      };
    };

  testScript = ''
    machine.start()

    machine.wait_for_unit("gotify-server.service")
    machine.wait_for_open_port(3000)

    token = machine.succeed(
        "curl --fail -sS -X POST localhost:3000/application -F name=nixos "
        + '-H "Authorization: Basic $(echo -ne "admin:admin" | base64 --wrap 0)" '
        + "| jq .token | xargs echo -n"
    )

    usertoken = machine.succeed(
        "curl --fail -sS -X POST localhost:3000/client -F name=nixos "
        + '-H "Authorization: Basic $(echo -ne "admin:admin" | base64 --wrap 0)" '
        + "| jq .token | xargs echo -n"
    )

    machine.succeed(
        f"curl --fail -sS -X POST 'localhost:3000/message?token={token}' -H 'Accept: application/json' "
        + "-F title=Gotify -F message=Works"
    )

    title = machine.succeed(
        f"curl --fail -sS 'localhost:3000/message?since=0&token={usertoken}' | jq '.messages|.[0]|.title' | xargs echo -n"
    )

    assert title == "Gotify"

    # Ensure that the UI responds with a successful code and that the
    # response is not empty
    result = machine.succeed("curl -fsS localhost:3000")
    assert result, "HTTP response from localhost:3000 must not be empty!"
  '';
}
