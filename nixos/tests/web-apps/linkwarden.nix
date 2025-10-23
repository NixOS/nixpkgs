{ ... }:
{
  name = "linkwarden-nixos";

  nodes.machine =
    { pkgs, ... }:
    let
      secretsFile = pkgs.writeText "linkwarden-secret-env" ''
        VERY_SENSITIVE_SECRET
      '';
      webroot = pkgs.runCommand "webroot" { } ''
        mkdir $out
        cd $out
        echo '<!DOCTYPE html><html><body><h1>HELLO LINKWARDEN</h1></body></html>' > index.html
      '';
    in
    {
      services.linkwarden = {
        enable = true;
        enableRegistration = true;
        secretFiles = {
          NEXTAUTH_SECRET = toString secretsFile;
        };
        environment = {
          NEXTAUTH_URL = "http://localhost:3000/api/v1/auth";
        };
      };

      services.nginx = {
        enable = true;
        virtualHosts.localhost.root = webroot;
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("linkwarden.service")
    machine.wait_for_unit("linkwarden-worker.service")

    machine.wait_for_open_port(3000)
    machine.succeed("curl --fail -s http://localhost:3000/")

    machine.succeed("curl -L --fail -s --data '{\"name\":\"Admin\",\"username\":\"admin\",\"password\":\"adminadmin\"}' -H 'Content-Type: application/json' -X POST http://localhost:3000/api/v1/users")

    response = machine.succeed("curl -L --fail -s -c next_cookies.txt -H 'Content-Type: application/json' -X GET http://localhost:3000/api/v1/auth/csrf")
    csrfToken = json.loads(response)['csrfToken']

    machine.succeed("curl -L --fail -s -b next_cookies.txt -c next_cookies.txt -H 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=adminadmin' --data-urlencode 'csrfToken=%s' http://localhost:3000/api/v1/auth/callback/credentials" % csrfToken)

    curlCmd = "curl -L --fail -s -b next_cookies.txt -H 'Content-Type: application/json' "

    machine.succeed(curlCmd + "--data '{\"url\":\"http://localhost/\"}' -X POST http://localhost:3000/api/v1/links")

    machine.succeed(curlCmd + "-X GET http://localhost:3000/api/v1/links")

    machine.wait_for_file("/var/lib/linkwarden/archives/1/1.html")
    machine.succeed("grep -q '<h1>HELLO LINKWARDEN</h1>' </var/lib/linkwarden/archives/1/1.html")
  '';
}
