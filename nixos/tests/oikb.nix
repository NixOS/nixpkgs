{ lib, pkgs, ... }:

let
  # Exercise the documented override path: add the optional S3 dependencies.
  oikb = pkgs.oikb.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ old.passthru.optional-dependencies.s3;
  });
in
{
  name = "oikb";
  meta.maintainers = [ lib.maintainers.gaelj ];

  nodes.machine = {
    services.oikb = {
      enable = true;
      package = oikb;
      openWebUiUrl = "http://127.0.0.1:3000";
      configPath = "/etc/oikb/daemon.yaml";
      daemonConfig = ''
        sources:
          - source: /srv/oikb
            kb-id: test-kb
            interval: 1h
      '';
    };

    systemd.tmpfiles.rules = [ "d /srv/oikb 0755 root root -" ];
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("oikb.service")
    machine.wait_for_open_port(8080)

    machine.succeed("curl -fsS http://localhost:8080/health/ready | grep -q ready")

    exec_start = machine.succeed("systemctl show -p ExecStart --value oikb.service")
    assert "${oikb}/bin/oikb" in exec_start, exec_start
    assert "/etc/oikb/daemon.yaml" in exec_start, exec_start
  '';
}
