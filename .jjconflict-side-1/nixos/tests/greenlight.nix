{
  lib,
  pkgs,
  ...
}:

{
  name = "greenlight";
  meta = {
    maintainers = [ lib.maintainers.onny ];
    teams = [ lib.teams.ngi ];
  };

  nodes = {
    greenlight = {
      services.greenlight = {
        enable = true;
        # For local testing without SSL
        settings = {
          RAILS_ENV = "development";
          RAILS_DUMP_SCHEMA = false;
        };
      };
    };
  };

  testScript = ''
    greenlight.start
    greenlight.wait_for_unit("greenlight-web.service")
    greenlight.wait_for_open_port(80)
    greenlight.wait_for_open_port(6346)
    greenlight.succeed("curl -sSfL http://greenlight:80 | grep 'BigBlueButton open source conferencing system'")

    greenlight.succeed(
        "greenlight-rake admin:create",
    )

    # grab session cookie + CSRF token
    greenlight.succeed("curl -sS -c /tmp/cookies.txt http://localhost/ -o /tmp/page.html")
    csrf_token = greenlight.succeed(
        "grep -o 'name=\"csrf-token\" content=\"[^\"]*\"' /tmp/page.html "
        "| sed 's/.*content=\"//;s/\"$//'"
    ).strip()

    # log in with default credentials
    login_result = greenlight.succeed(
        f"curl -sSf -c /tmp/cookies.txt -b /tmp/cookies.txt "
        f"-X POST http://localhost/api/v1/sessions.json "
        f"-H 'Content-Type: application/json' -H 'Accept: application/json' "
        f"-H 'X-CSRF-Token: {csrf_token}' "
        f"-d '{{\"session\":{{\"email\":\"admin@example.com\",\"password\":\"Administrator1!\"}}}}'"
    )
    assert '"signed_in":true' in login_result, f"login failed: {login_result}"
  '';

}
