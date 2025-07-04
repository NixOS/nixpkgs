{ lib, pkgs, ... }:

{
  name = "powerdns-recursor";
  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

  nodes.server = {
    services.pdns-recursor.enable = true;
    services.pdns-recursor.exportHosts = true;
    services.pdns-recursor.old-settings.dnssec-log-bogus = true;
    networking.hosts."192.0.2.1" = [ "example.com" ];
  };

  testScript = ''
    with subtest("pdns-recursor is running"):
      server.wait_for_unit("pdns-recursor")
      server.wait_for_open_port(53)

    with subtest("can resolve names"):
      assert "192.0.2.1" in server.succeed("host example.com localhost")

    with subtest("old-settings have been merged in"):
      server.succeed("${lib.getExe pkgs.yq-go} -e .dnssec.log_bogus /etc/pdns-recursor/recursor.yml")
  '';
}
