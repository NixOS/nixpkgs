{ lib, ... }:
let
  kumaHost = "127.0.0.1";
  kumaPort = "3001";
  kumaUrl = "http://${kumaHost}:${kumaPort}/";
  kumaUser = "admin";
  kumaPassword = "pa55word";
in
{
  name = "autokuma";
  meta.maintainers = with lib.maintainers; [ kruemmelspalter ];

  containers.machine =
    { pkgs, lib, ... }:
    {
      # only for testing
      environment.systemPackages = [
        pkgs.sqlite
        pkgs.autokuma
      ];

      services = {
        uptime-kuma = {
          enable = true;
          settings = {
            HOST = kumaHost;
            PORT = kumaPort;
          };
        };

        autokuma = {
          enable = true;
          settings = {
            kuma = {
              url = kumaUrl;
              username = kumaUser;
              password = kumaPassword;
            };
            docker.enabled = true;
          };
          staticMonitors.config = [
            {
              name = "uptime-kuma itself";
              url = kumaUrl;
              type = "http";
            }
          ];
        };
      };

      # do not autostart autokuma, start only when done with setup in test
      systemd.services.autokuma.wantedBy = lib.mkForce [ ];

      virtualisation.docker.enable = true;
    };

  extraPythonPackages = p: [ p.bcrypt ];

  testScript = ''
    import json
    import bcrypt

    # wait for uptime kuma to open the http port; by then, the db is initialized
    machine.start()
    machine.wait_for_unit("uptime-kuma.service")
    machine.wait_for_open_port(${kumaPort})

    # provision user
    pwhash = bcrypt.hashpw("${kumaPassword}".encode("utf-8"), bcrypt.gensalt()).decode().replace("$", "\\$")
    machine.succeed(f"echo \"insert into user (username, password) values ('${kumaUser}', '{pwhash}');\" | sqlite3 /var/lib/uptime-kuma/kuma.db");

    machine.wait_for_unit("docker.service")
    machine.wait_for_unit("docker.socket")
    machine.succeed("tar cv --files-from /dev/null | docker import - scratchimg")
    machine.succeed(
        "docker run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin --label 'kuma.docker-whoami.http.name=dockertest' --label 'kuma.docker-whoami.http.url=http://example.com/' scratchimg /bin/sleep 20"
    )
    machine.wait_until_succeeds("docker ps | grep sleeping")

    machine.systemctl("start autokuma")
    machine.wait_for_unit("autokuma.service")

    # give autokuma time to register everything
    machine.succeed("sleep 5")

    # get all monitors from uptime kuma (using the kuma cli provided by autokuma)
    monitors = machine.succeed("kuma monitor list --url '${kumaUrl}' --username '${kumaUser}' --password '${kumaPassword}'")
    monitors = json.loads(monitors).values()

    def check_static_monitor(e):
      return e["type"] == "http" and e["name"] == "uptime-kuma itself" and e["url"] == "${kumaUrl}"
    assert bool(list(filter(check_static_monitor, monitors))), "static monitor isn't added in uptime-kuma"

    def check_docker_monitor(e):
      return e["type"] == "http" and e["name"] == "dockertest" and e["url"] == "http://example.com/"
    assert bool(list(filter(check_docker_monitor, monitors))), "docker monitor isn't added in uptime-kuma"
  '';
}
