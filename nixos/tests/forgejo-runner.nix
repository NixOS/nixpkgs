{
  lib,
  ...
}:

{
  name = "forgejo-runner";
  meta.maintainers = lib.teams.forgejo.members;

  nodes.machine = {
    virtualisation.podman = {
      enable = true;
      dockerSocket.enable = true;
    };

    environment.etc."forgejo-runner-token".text = "0123456789abcdef0123456789abcdef01234567";

    services.forgejo-runner.instances.codeberg = {
      enable = true;
      settings = {
        log.level = "info";
        runner = {
          name = "test-runner";
          capacity = 2;
        };
        container.network = "bridge";
        cache.enabled = true;
      };
      connections.codeberg = {
        url = "https://codeberg.org/";
        uuid = "33834eef-e758-48c4-a676-1745426747aa";
        tokenFile = "/etc/forgejo-runner-token";
        labels = [
          "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-latest"
        ];
        fetchInterval = "30s";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    unit = machine.succeed("systemctl cat forgejo-runner-codeberg.service")
    assert "LoadCredential=codeberg-token:/etc/forgejo-runner-token" in unit
    assert "DOCKER_HOST=unix:///run/podman/podman.sock" in unit
    assert "SupplementaryGroups=podman" in unit

    config_path = machine.succeed(
        "systemctl show forgejo-runner-codeberg.service -p ExecStart --value "
        "| sed -n 's/.* --config \\([^ ;]*\\).*/\\1/p'"
    ).strip()
    config = machine.succeed(f"cat {config_path}")

    assert "server:" in config
    assert "connections:" in config
    assert "codeberg:" in config
    assert "url: https://codeberg.org/" in config
    assert "uuid: 33834eef-e758-48c4-a676-1745426747aa" in config
    assert "token_url: file:$CREDENTIALS_DIRECTORY/codeberg-token" in config
    assert "fetch_interval: 30s" in config
    assert "token: " not in config
  '';
}
