{ lib, pkgs, ... }:

let
  mockPlayit = pkgs.writeShellApplication {
    name = "playitd";
    text = ''
      test "$(cat "$CREDENTIALS_DIRECTORY/secret")" = 'secret_key = "test-secret"'

      mkdir -p "$STATE_DIRECTORY/certs"
      touch "$STATE_DIRECTORY/certs/ca.pem"
      echo "mock playitd started" >> "$LOGS_DIRECTORY/playit.log"

      sleep infinity
    '';
  };
in
{
  name = "playit";

  meta.maintainers = with lib.maintainers; [ pedorich-n ];

  nodes.machine = {
    services.playit = {
      enable = true;
      secretPath = "/etc/playit/secret.toml";
      package = mockPlayit;
    };

    environment.etc."playit/secret.toml" = {
      mode = "0400";
      text = ''secret_key = "test-secret"'';
    };
  };

  testScript = ''
    start_all()

    with subtest("service starts and reads its credential"):
        machine.wait_for_unit("playit.service")

    with subtest("runtime and state directories"):
        machine.succeed("test \"$(stat -c %a /run/playit)\" = 755")
        machine.succeed("test \"$(stat -L -c %a /var/lib/playit)\" = 700")
        machine.wait_for_file("/var/lib/playit/certs/ca.pem")
        machine.wait_for_file("/var/log/playit/playit.log")

    with subtest("exec arguments"):
        machine.succeed("grep -qF -- '--secret-path ''${CREDENTIALS_DIRECTORY}/secret' /etc/systemd/system/playit.service")
        machine.succeed("grep -qF -- '--log-path ''${LOGS_DIRECTORY}/playit.log' /etc/systemd/system/playit.service")
        machine.succeed("grep -qF -- '--cert-dir ''${STATE_DIRECTORY}/certs' /etc/systemd/system/playit.service")
        machine.succeed("systemctl show -P DynamicUser playit.service | grep -qx yes")
  '';
}
