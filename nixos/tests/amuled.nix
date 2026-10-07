{ lib, pkgs, ... }:

let
  adminPassword = "admin-secret";

  # No eD2k server nor Kad network is reachable from the test: the two peers
  # bootstrap a Kad network between themselves (aMule only asks sources for
  # downloads while connected to a network) and the leecher finds the seeder
  # through the `sources` field of the ed2k link.
  # Both require accepting peers on private addresses.
  node = {
    environment.systemPackages = [
      pkgs.curl
      pkgs.jq
    ];
    services.amule = {
      enable = true;
      openPeerPorts = true;
      ExternalConnectPasswordFile = pkgs.writeText "amule-ec-password" "ec-secret";
      AmuleApiAdminPasswordFile = pkgs.writeText "amule-api-password" adminPassword;
      settings = {
        eMule.FilterLanIPs = 0;
        AmuleApi.Enabled = 1;
      };
    };
  };
in
{
  name = "amuled";

  meta.maintainers = with lib.maintainers; [ aciceri ];

  nodes = {
    seeder = {
      imports = [ node ];
      services.amule = {
        AmuleApiAdminPasswordFile = lib.mkForce "/run/amule admin password";
        settings.ExternalConnect.ECPort = 14712;
      };
      # Observe individual startup failures rather than automatic retries.
      systemd.services.amuled.serviceConfig.Restart = lib.mkForce "no";
    };
    leecher = node;
  };

  testScript =
    { nodes, ... }:
    ''
      import datetime as dt
      import json
      import shlex

      api = "http://127.0.0.1:4713/api/v1"
      incoming = "/var/lib/amuled/Incoming"


      def login(machine):
          machine.wait_until_succeeds(f"curl -sf {api}/health | jq -e '.ec_connected'")
          body = json.dumps({"password": "${adminPassword}"})
          return machine.succeed(
              f"curl -sf -X POST '{api}/auth/login?include_token=true' "
              f"-H 'Content-Type: application/json' -d {shlex.quote(body)} | jq -r .token"
          ).strip()


      def call(machine, token, method, path, body=None):
          cmd = f"curl -sf -X {method} -H 'Authorization: Bearer {token}' {api}{path}"
          if body is not None:
              cmd += f" -H 'Content-Type: application/json' -d {shlex.quote(json.dumps(body))}"
          return machine.succeed(cmd)


      start_all()
      with subtest("missing or unreadable admin secrets prevent startup"):
          secret = shlex.quote("${nodes.seeder.services.amule.AmuleApiAdminPasswordFile}")
          seeder.wait_until_succeeds("systemctl is-failed amuled.service")
          seeder.fail("test -e /var/lib/amuled/amuleapi-passwords")
          seeder.succeed(
              f"install -m 600 ${pkgs.writeText "amule-admin-secret" adminPassword} {secret}",
              "systemctl reset-failed amuled.service",
          )
          seeder.fail("systemctl start amuled.service")
          seeder.fail("test -e /var/lib/amuled/amuleapi-passwords")
          seeder.succeed(
              f"chown amule:amule {secret}",
              "systemctl reset-failed amuled.service",
              "systemctl start amuled.service",
          )

      for machine in (seeder, leecher):
          machine.wait_for_unit("amuled.service")
          machine.wait_for_open_port(4662)
          machine.wait_for_open_port(4713)

      with subtest("amuleapi serves the Web UI and enforces the admin password"):
          seeder.succeed("curl -sf http://127.0.0.1:4713/ | grep -i '<html'")
          seeder.fail(
              f"curl -sf -X POST '{api}/auth/login' -H 'Content-Type: application/json' "
              """-d '{"password":"wrong"}'"""
          )
          seeder_token = login(seeder)
          leecher_token = login(leecher)

      with subtest("seeder shares a file"):
          seeder.succeed(
              f"head -c 3M /dev/urandom > {incoming}/payload.bin",
              f"chown amule:amule {incoming}/payload.bin",
          )
          call(seeder, seeder_token, "POST", "/shared_reload")
          seeder.wait_until_succeeds(
              f"curl -sf -H 'Authorization: Bearer {seeder_token}' {api}/shared "
              "| jq -e '.shared[] | select(.name == \"payload.bin\")'",
              timeout=dt.timedelta(minutes=2),
          )
          shared = json.loads(call(seeder, seeder_token, "GET", "/shared"))
          link = next(f["ed2k_link"] for f in shared["shared"] if f["name"] == "payload.bin")

      with subtest("peers form a LAN Kad network"):
          for machine, token, peer in (
              (seeder, seeder_token, "${nodes.leecher.networking.primaryIPAddress}"),
              (leecher, leecher_token, "${nodes.seeder.networking.primaryIPAddress}"),
          ):
              call(machine, token, "POST", "/kad/bootstrap", {"ip": peer, "port": 4672})
          for machine, token in ((seeder, seeder_token), (leecher, leecher_token)):
              machine.wait_until_succeeds(
                  f"curl -sf -H 'Authorization: Bearer {token}' {api}/status "
                  "| jq -e '.kad.state == \"connected\"'",
                  timeout=dt.timedelta(minutes=2),
              )

      with subtest("leecher downloads it from the seeder"):
          link += "|sources,${nodes.seeder.networking.primaryIPAddress}:4662|/"
          call(leecher, leecher_token, "POST", "/downloads", {"links": [link]})
          leecher.wait_for_file(f"{incoming}/payload.bin", timeout=dt.timedelta(minutes=10))
          expected = seeder.succeed(f"sha256sum < {incoming}/payload.bin")
          leecher.wait_until_succeeds(
              f"[ \"$(sha256sum < {incoming}/payload.bin)\" = {shlex.quote(expected.strip())} ]",
              timeout=dt.timedelta(minutes=1),
          )
    '';
}
