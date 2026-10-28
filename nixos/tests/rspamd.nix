{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  initMachine = ''
    start_all()
    machine.wait_for_unit("rspamd.service")
    machine.succeed("id rspamd >/dev/null")
  '';
  checkSocket = socket: user: group: mode: ''
    machine.succeed(
        "ls ${socket} >/dev/null",
        '[[ "$(stat -c %U ${socket})" == "${user}" ]]',
        '[[ "$(stat -c %G ${socket})" == "${group}" ]]',
        '[[ "$(stat -c %a ${socket})" == "${mode}" ]]',
    )
  '';
  simple =
    name: enableIPv6:
    makeTest {
      name = "rspamd-${name}";
      nodes.machine = {
        services.rspamd.enable = true;
        networking.enableIPv6 = enableIPv6;
      };
      testScript = ''
        start_all()
        machine.wait_for_unit("multi-user.target")
        machine.wait_for_open_port(11334)
        machine.wait_for_unit("rspamd.service")
        machine.succeed("id rspamd >/dev/null")
        ${checkSocket "/run/rspamd/rspamd.sock" "rspamd" "rspamd" "660"}
        machine.sleep(10)
        machine.log(machine.succeed("cat /etc/rspamd/rspamd.conf"))
        machine.log(
            machine.succeed("grep 'CONFDIR/worker-controller.inc' /etc/rspamd/rspamd.conf")
        )
        machine.log(machine.succeed("grep 'CONFDIR/worker-normal.inc' /etc/rspamd/rspamd.conf"))
        machine.log(machine.succeed("systemctl cat rspamd.service"))
        machine.log(machine.succeed("curl http://localhost:11334/auth"))
        machine.log(machine.succeed("curl http://127.0.0.1:11334/auth"))
        ${optionalString enableIPv6 ''machine.log(machine.succeed("curl http://[::1]:11334/auth"))''}
        # would not reformat
      '';
    };
in
{
  simple = simple "simple" true;
  ipv4only = simple "ipv4only" false;
  deprecated = makeTest {
    name = "rspamd-deprecated";
    nodes.machine = {
      services.rspamd = {
        enable = true;
        workers.normal.bindSockets = [
          {
            socket = "/run/rspamd/rspamd.sock";
            mode = "0600";
            owner = "rspamd";
            group = "rspamd";
          }
        ];
        workers.controller.bindSockets = [
          {
            socket = "/run/rspamd/rspamd-worker.sock";
            mode = "0666";
            owner = "rspamd";
            group = "rspamd";
          }
        ];
      };
    };

    testScript = ''
      ${initMachine}
      machine.wait_for_file("/run/rspamd/rspamd.sock")
      ${checkSocket "/run/rspamd/rspamd.sock" "rspamd" "rspamd" "600"}
      ${checkSocket "/run/rspamd/rspamd-worker.sock" "rspamd" "rspamd" "666"}
      machine.log(machine.succeed("cat /etc/rspamd/rspamd.conf"))
      machine.log(
          machine.succeed("grep 'CONFDIR/worker-controller.inc' /etc/rspamd/rspamd.conf")
      )
      machine.log(machine.succeed("grep 'CONFDIR/worker-normal.inc' /etc/rspamd/rspamd.conf"))
      machine.log(machine.succeed("rspamc -h /run/rspamd/rspamd-worker.sock stat"))
      machine.log(
          machine.succeed(
              "curl --unix-socket /run/rspamd/rspamd-worker.sock http://localhost/ping"
          )
      )
    '';
  };

  bindports = makeTest {
    name = "rspamd-bindports";
    nodes.machine = {
      services.rspamd = {
        enable = true;
        workers.normal.bindSockets = [
          {
            socket = "/run/rspamd/rspamd.sock";
            mode = "0600";
            owner = "rspamd";
            group = "rspamd";
          }
        ];
        workers.controller.bindSockets = [
          {
            socket = "/run/rspamd/rspamd-worker.sock";
            mode = "0666";
            owner = "rspamd";
            group = "rspamd";
          }
        ];
        workers.controller2 = {
          type = "controller";
          bindSockets = [ "0.0.0.0:11335" ];
          extraConfig = ''
            static_dir = "''${WWWDIR}";
            secure_ip = null;
            password = "verysecretpassword";
          '';
        };
      };
    };

    testScript = ''
      ${initMachine}
      machine.wait_for_file("/run/rspamd/rspamd.sock")
      ${checkSocket "/run/rspamd/rspamd.sock" "rspamd" "rspamd" "600"}
      ${checkSocket "/run/rspamd/rspamd-worker.sock" "rspamd" "rspamd" "666"}
      machine.log(machine.succeed("cat /etc/rspamd/rspamd.conf"))
      machine.log(
          machine.succeed("grep 'CONFDIR/worker-controller.inc' /etc/rspamd/rspamd.conf")
      )
      machine.log(machine.succeed("grep 'CONFDIR/worker-normal.inc' /etc/rspamd/rspamd.conf"))
      machine.log(
          machine.succeed(
              "grep 'LOCAL_CONFDIR/override.d/worker-controller2.inc' /etc/rspamd/rspamd.conf"
          )
      )
      machine.log(
          machine.succeed(
              "grep 'verysecretpassword' /etc/rspamd/override.d/worker-controller2.inc"
          )
      )
      machine.wait_until_succeeds(
          "journalctl -u rspamd | grep -i 'starting controller process' >&2"
      )
      machine.log(machine.succeed("rspamc -h /run/rspamd/rspamd-worker.sock stat"))
      machine.log(
          machine.succeed(
              "curl --unix-socket /run/rspamd/rspamd-worker.sock http://localhost/ping"
          )
      )
      machine.log(machine.succeed("curl http://localhost:11335/ping"))
    '';
  };
  customLuaRules = makeTest {
    name = "rspamd-custom-lua-rules";
    nodes.machine = {
      environment.etc."tests/no-muh.eml".text = ''
        From: Sheep1<bah@example.com>
        To: Sheep2<mah@example.com>
        Subject: Evil cows

        I find cows to be evil don't you?
      '';
      environment.etc."tests/muh.eml".text = ''
        From: Cow<cow@example.com>
        To: Sheep2<mah@example.com>
        Subject: Evil cows

        Cows are majestic creatures don't Muh agree?
      '';
      services.rspamd = {
        enable = true;
        locals = {
          "antivirus.conf" = mkIf false {
            text = ''
              clamav {
                action = "reject";
                symbol = "CLAM_VIRUS";
                type = "clamav";
                log_clean = true;
                servers = "/run/clamav/clamd.ctl";
              }
            '';
          };
          "redis.conf" = {
            enable = false;
            text = ''
              servers = "127.0.0.1";
            '';
          };
          "groups.conf".text = ''
            group "cows" {
              symbol {
                NO_MUH = {
                  weight = 1.0;
                  description = "Mails should not muh";
                }
              }
            }
          '';
        };
        localLuaRules = pkgs.writeText "rspamd.local.lua" ''
          local rspamd_logger = require "rspamd_logger"
          rspamd_config.NO_MUH = {
            callback = function (task)
              local parts = task:get_text_parts()
              if parts then
                for _,part in ipairs(parts) do
                  local content = tostring(part:get_content())
                  rspamd_logger.infox(rspamd_config, 'Found content %s', content)
                  local found = string.find(content, "Muh");
                  rspamd_logger.infox(rspamd_config, 'Found muh %s', tostring(found))
                  if found then
                    return true
                  end
                end
              end
              return false
            end,
            score = 5.0,
            description = 'Allow no cows',
            group = "cows",
          }
          rspamd_logger.infox(rspamd_config, 'Work dammit!!!')
        '';
      };
    };
    testScript = ''
      ${initMachine}
      machine.wait_for_open_port(11334)
      machine.log(machine.succeed("cat /etc/rspamd/rspamd.conf"))
      machine.log(machine.succeed("cat /etc/rspamd/rspamd.local.lua"))
      machine.log(machine.succeed("cat /etc/rspamd/local.d/groups.conf"))
      # Verify that redis.conf was not written
      machine.fail("cat /etc/rspamd/local.d/redis.conf >&2")
      # Verify that antivirus.conf was not written
      machine.fail("cat /etc/rspamd/local.d/antivirus.conf >&2")
      ${checkSocket "/run/rspamd/rspamd.sock" "rspamd" "rspamd" "660"}
      machine.log(
          machine.succeed("curl --unix-socket /run/rspamd/rspamd.sock http://localhost/ping")
      )
      machine.log(machine.succeed("rspamc -h 127.0.0.1:11334 stat"))
      machine.log(machine.succeed("cat /etc/tests/no-muh.eml | rspamc -h 127.0.0.1:11334"))
      machine.log(
          machine.succeed("cat /etc/tests/muh.eml | rspamc -h 127.0.0.1:11334 symbols")
      )
      machine.wait_until_succeeds("journalctl -u rspamd | grep -i muh >&2")
      machine.log(
          machine.fail(
              "cat /etc/tests/no-muh.eml | rspamc -h 127.0.0.1:11334 symbols | grep NO_MUH"
          )
      )
      machine.log(
          machine.succeed(
              "cat /etc/tests/muh.eml | rspamc -h 127.0.0.1:11334 symbols | grep NO_MUH"
          )
      )
    '';
  };
  postfixIntegration = makeTest {
    name = "rspamd-postfix-integration";
    nodes.machine = {
      environment.systemPackages = with pkgs; [ msmtp ];
      environment.etc."tests/gtube.eml".text = ''
        From: Sheep1<bah@example.com>
        To: Sheep2<tester@example.com>
        Subject: Evil cows

        I find cows to be evil don't you?

        XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X
      '';
      environment.etc."tests/example.eml".text = ''
        From: Sheep1<bah@example.com>
        To: Sheep2<tester@example.com>
        Subject: Evil cows

        I find cows to be evil don't you?
      '';
      users.users.tester = {
        isNormalUser = true;
        password = "test";
      };
      services.postfix = {
        enable = true;
        settings.main.mydestination = [ "example.com" ];
      };
      services.rspamd = {
        enable = true;
        postfix.enable = true;
        workers.rspamd_proxy.type = "rspamd_proxy";
      };
    };
    testScript = ''
      ${initMachine}
      machine.wait_for_open_port(11334)
      machine.wait_for_open_port(25)
      ${checkSocket "/run/rspamd/rspamd-milter.sock" "rspamd" "postfix" "660"}
      machine.log(machine.succeed("rspamc -h 127.0.0.1:11334 stat"))
      machine.log(
          machine.succeed(
              "msmtp --host=localhost -t --read-envelope-from < /etc/tests/example.eml"
          )
      )
      machine.log(
          machine.fail(
              "msmtp --host=localhost -t --read-envelope-from < /etc/tests/gtube.eml"
          )
      )

      machine.wait_until_fails('[ "$(postqueue -p)" != "Mail queue is empty" ]')
      machine.fail("journalctl -u postfix | grep -i error >&2")
    '';
  };
}
