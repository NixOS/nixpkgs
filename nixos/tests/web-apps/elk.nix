{ lib, ... }:
{
  name = "elk-zone";

  meta.maintainers = with lib.maintainers; [ onny ];

  nodes.machine =
    { ... }:
    {
      services.elk = {
        enable = true;
        settings = {
          NUXT_ADMIN_KEY = "test-key";
          NUXT_PUBLIC_DEFAULT_SERVER = "mastodon.social";
          NUXT_PUBLIC_SINGLE_INSTANCE = true;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("elk.service")
    machine.wait_for_open_port(3000)

    # The pre-rendered web client is served.
    machine.succeed(
        "curl --fail --silent http://localhost:3000/"
        " | grep -F 'id=\"__nuxt\"'"
    )
    machine.succeed(
        "curl --fail --silent http://localhost:3000/"
        " | grep -F 'og:title\" content=\"Elk\"'"
    )

    # Static assets are served with a sensible content type.
    machine.succeed(
        "curl --fail --silent --head http://localhost:3000/manifest-en-US.webmanifest"
        " | grep -Fi 'content-type: application/manifest+json'"
    )

    # nuxt-security is wired up.
    machine.succeed(
        "curl --fail --silent --head http://localhost:3000/"
        " | grep -Fi 'content-security-policy:'"
    )

    # Settings are passed to the server process.
    machine.succeed(
        "systemctl show elk.service --property=Environment"
        " | grep -F 'NUXT_ADMIN_KEY=test-key'"
    )

    # Public defaults are baked into the client bundle, cf. https://github.com/elk-zone/elk/issues/2997
    machine.succeed(
        "curl --fail --silent http://localhost:3000/"
        " | grep -F 'defaultServer:\"mastodon.social\"'"
    )
    machine.succeed(
        "curl --fail --silent http://localhost:3000/"
        " | grep -F 'singleInstance:true'"
    )

    # The list of logged-in servers is read from the file system storage in
    # the state directory, which has to be picked up from the settings.
    machine.succeed(
        "mkdir -p /var/lib/elk/v4/example.social"
        " && echo '{}' > /var/lib/elk/v4/example.social/token.json"
    )
    machine.succeed(
        "curl --fail --silent http://localhost:3000/api/list-servers"
        " | grep -F 'example.social'"
    )

    # The admin endpoint is protected by the admin key from the settings.
    machine.succeed(
        "curl --fail --silent 'http://localhost:3000/api/example.social/clear?key=wrong'"
        " | grep -F '\"error\":\"incorrect key\"'"
    )
  '';
}
