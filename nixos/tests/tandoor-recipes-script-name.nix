import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "tandoor-recipes-script-name";

    nodes.machine =
      { pkgs, nodes, ... }:
      {
        services.tandoor-recipes = {
          enable = true;
          extraConfig = {
            SCRIPT_NAME = "/any/path";
            STATIC_URL = "${nodes.machine.services.tandoor-recipes.extraConfig.SCRIPT_NAME}/static/";
          };
        };
      };

    testScript =
      { nodes, ... }:
      let
        inherit (nodes.machine.services.tandoor-recipes) address port;
        inherit (nodes.machine.services.tandoor-recipes.extraConfig) SCRIPT_NAME;
      in
      ''
        from html.parser import HTMLParser

        origin_url = "http://${address}:${toString port}"
        base_url = f"{origin_url}${SCRIPT_NAME}"
        login_path = "/admin/login/"
        login_url = f"{base_url}{login_path}"

        cookie_jar_path = "/tmp/cookies.txt"
        curl = f"curl --cookie {cookie_jar_path} --cookie-jar {cookie_jar_path} --fail --header 'Origin: {origin_url}' --show-error --silent"

        print("Wait for the service to respond")
        machine.wait_for_unit("tandoor-recipes.service")
        machine.wait_until_succeeds(f"{curl} {login_url}")

        username = "username"
        password = "password"

        print("Create admin user")
        machine.succeed(
            f"DJANGO_SUPERUSER_PASSWORD='{password}' /var/lib/tandoor-recipes/tandoor-recipes-manage createsuperuser --no-input --username='{username}' --email=nobody@example.com"
        )

        print("Get CSRF token for later requests")
        csrf_token = machine.succeed(f"grep csrftoken {cookie_jar_path} | cut --fields=7").rstrip()

        print("Log in as admin user")
        machine.succeed(
            f"{curl} --data 'csrfmiddlewaretoken={csrf_token}' --data 'username={username}' --data 'password={password}' {login_url}"
        )

        print("Get the contents of the logged in main page")
        logged_in_page = machine.succeed(f"{curl} --location {base_url}")

        class UrlParser(HTMLParser):
            def __init__(self):
                super().__init__()

                self.urls: list[str] = []

            def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
                if tag == "form":
                    for name, value in attrs:
                        if name == "action" and value is not None:
                            assert not value.endswith(login_path)
                            break

                if tag != "a":
                    return

                for name, value in attrs:
                    if name == "href" and value is not None:
                        if value.startswith(base_url):
                            self.urls.append(value)
                        elif value.startswith("/"):
                            self.urls.append(f"{origin_url}{value}")
                        else:
                            print("Ignoring external URL: {value}")

                        break

        parser = UrlParser()
        parser.feed(logged_in_page)

        for url in parser.urls:
            with subtest(f"Verify that {url} can be reached"):
                machine.succeed(f"{curl} {url}")
      '';

    meta.maintainers = with lib.maintainers; [ l0b0 ];
  }
)
