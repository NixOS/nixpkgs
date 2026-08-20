{ lib, ... }:
{
  name = "chaptarr";
  meta.maintainers = [ lib.maintainers.lnk3 ];

  nodes.machine = { pkgs, ... }: {
    services.chaptarr.enable = true;
    services.chaptarr.openFirewall = true;
    services.chaptarr.settings.server.port = 9999;

    environment.systemPackages = [ pkgs.nftables ];

    services.chaptarr.settings.postgres.host = "/run/postgresql";
    services.postgresql.enable = true;
    services.postgresql.initialScript = pkgs.writeText "chaptarr-init.sql" ''
      CREATE ROLE chaptarr WITH LOGIN;
      CREATE DATABASE "chaptarr-main" OWNER chaptarr;
      CREATE DATABASE "chaptarr-log" OWNER chaptarr;
      CREATE DATABASE "chaptarr-cache" OWNER chaptarr;
    '';
  };

  testScript = ''
    import re

    machine.wait_for_unit("chaptarr.service")
    machine.wait_for_open_port(9999, timeout=60)
    machine.succeed("curl --fail http://localhost:9999/")
    machine.succeed("nft list ruleset | grep 9999")

    machine.succeed("id chaptarr")
    machine.succeed("awk -F: '/^chaptarr:/{print $2}' /etc/shadow | grep -q '!'")

    data_dir = "/var/lib/chaptarr"
    machine.succeed(f"test -d {data_dir}")
    machine.succeed(f"stat -c '%U %G %a' {data_dir} | grep 'chaptarr chaptarr 700'")

    output = machine.succeed("systemd-analyze security chaptarr.service")
    match = re.search(r"Overall exposure level.*?(\d+\.?\d*)", output)
    assert match is not None, "Could not parse exposure level from systemd-analyze output"
    score = float(match.group(1))
    assert score <= 3.0, f"Exposure level too high: {score}"

    journal = machine.succeed("journalctl -u chaptarr --no-pager -b")
    assert "EPIC FAIL" not in journal, "Chaptarr logged a fatal error"
    assert "Fatal" not in journal, "Chaptarr logged a fatal error"

    after = machine.succeed("systemctl show chaptarr.service --property=After --value")
    wants = machine.succeed("systemctl show chaptarr.service --property=Wants --value")
    assert "postgresql.service" in after, "chaptarr.service missing After=postgresql.service"
    assert "postgresql.service" in wants, "chaptarr.service missing Wants=postgresql.service"

    table_count = machine.succeed(
        "sudo -u postgres psql -d chaptarr-main -tAc "
        "\"select count(*) from information_schema.tables where table_schema='public'\""
        ).strip()
    assert int(table_count) > 0, "chaptarr created no tables in postgres — likely didn't connect"

    machine.succeed("systemctl restart chaptarr")
    machine.wait_for_unit("chaptarr.service")
    machine.wait_for_open_port(9999)
    machine.succeed("curl --fail http://localhost:9999/")
  '';
}
