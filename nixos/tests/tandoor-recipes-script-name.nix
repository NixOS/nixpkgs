import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "tandoor-recipes-script-name";

  nodes.machine = { pkgs, nodes, ... }: {
    services.tandoor-recipes = {
      enable = true;
      extraConfig = {
        SCRIPT_NAME = "/any/path";
        STATIC_URL = "${nodes.machine.services.tandoor-recipes.extraConfig.SCRIPT_NAME}/static/";
      };
    };
  };

  testScript = {nodes, ...}:
  let
    inherit (nodes.machine.services.tandoor-recipes) address port;
    inherit (nodes.machine.services.tandoor-recipes.extraConfig) SCRIPT_NAME;
  in
  ''
    username = "any_username"
    password = "any password"

    cookie_jar_path = "/tmp/cookies.txt"
    curl = f"curl --cookie {cookie_jar_path} --cookie-jar {cookie_jar_path} --fail --show-error --silent"

    login_url = "http://${address}:${toString port}${SCRIPT_NAME}/accounts/login/"

    # Wait for the service to respond
    machine.wait_for_unit("tandoor-recipes.service")
    machine.wait_until_succeeds(f"{curl} {login_url}")

    # Get CSRF token for later requests
    csrf_token = machine.succeed(f"grep csrftoken {cookie_jar_path} | cut --fields=7")

    machine.succeed(f"DJANGO_SUPERUSER_PASSWORD='{password}' ${pkgs.tandoor-recipes}/lib/tandoor-recipes/manage.py createsuperuser --no-input --username='{username}' --email=nobody@example.com")
    machine.succeed(f"{curl} --data csrfmiddlewaretoken={csrf_token}&username={username}&password={password}' --request POST {login_url}")
  '';

  meta.maintainers = with lib.maintainers; [ l0b0 ];
})
