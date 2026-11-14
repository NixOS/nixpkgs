{
  pkgs,
  ...
}:
let
  mockPlayit = pkgs.writeShellApplication {
    name = "playitd";
    text = ''
      secret_path="$CREDENTIALS_DIRECTORY/secret"
      if ! cat "$secret_path" >/dev/null; then
        echo "playitd: cannot read credential at $secret_path" >&2
        exit 1
      fi

      while [ $# -gt 0 ]; do
        if [ "$1" = "--cert-dir" ]; then
          cert_dir="$2"
        fi
        shift
      done
      mkdir -p "$cert_dir"
      touch "$cert_dir/ca.pem"

      sleep infinity
    '';
  };
in
{
  name = "playit";

  meta.maintainers = pkgs.playit.meta.maintainers;

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

    with subtest("daemon can write certificates"):
        machine.wait_for_file("/var/lib/playit/certs/ca.pem")
  '';
}
