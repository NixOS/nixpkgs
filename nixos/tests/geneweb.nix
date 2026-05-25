{ lib, ... }:
let
  port = 2318;
  wizardPass = "s3cret-wizard";
  friendPass = "s3cret-friend";
in
{
  name = "geneweb";
  meta.maintainers = [ lib.maintainers.darkone ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.geneweb = {
        enable = true;
        inherit port;
        openFirewall = true;
        wizardPasswordFile = pkgs.writeText "geneweb-wizard-pw" wizardPass;
        friendPasswordFile = pkgs.writeText "geneweb-friend-pw" friendPass;
        databases = {
          emptybase = { };
          imported.source = pkgs.writeText "geneweb-sample.gw" ''
            encoding: utf-8

            fam Smith John + Martin Mary
            beg
            - h Paul
            end
          '';
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("geneweb-init.service")
    machine.wait_for_unit("geneweb.service")
    machine.wait_for_open_port(${toString port})

    with subtest("HTTP server serves both declarative databases"):
        machine.succeed("curl -sS -f http://localhost:${toString port}")
        machine.succeed("curl -sS -f 'http://localhost:${toString port}?b=emptybase'")
        machine.succeed("curl -sS -f 'http://localhost:${toString port}?b=imported'")

    with subtest("declarative databases were created on disk"):
        machine.succeed("test -d /var/lib/geneweb/emptybase.gwb")
        machine.succeed("test -d /var/lib/geneweb/imported.gwb")

    with subtest("openFirewall opens the configured port"):
        machine.succeed(
            "iptables -S | grep -q ${toString port} || nft list ruleset | grep -q ${toString port}"
        )

    with subtest("password files are loaded as credentials and handed to gwd"):
        machine.succeed("ps -ww -C gwd -o args= | grep -- ${wizardPass}")
        machine.succeed("ps -ww -C gwd -o args= | grep -- ${friendPass}")

    with subtest("re-running geneweb-init never overwrites an existing base"):
        before = machine.succeed("stat -c %Y /var/lib/geneweb/imported.gwb").strip()
        machine.succeed("systemctl restart geneweb-init.service")
        machine.wait_for_unit("geneweb-init.service")
        after = machine.succeed("stat -c %Y /var/lib/geneweb/imported.gwb").strip()
        assert before == after, "imported.gwb was modified by re-running geneweb-init"
  '';
}
