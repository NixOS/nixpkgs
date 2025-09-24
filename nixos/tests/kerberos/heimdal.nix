import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "kerberos_server-heimdal";

    nodes = {
      server =
        { config, pkgs, ... }:
        {
          imports = [ ../common/user-account.nix ];

          users.users.alice.extraGroups = [ "wheel" ];

          services.getty.autologinUser = "alice";

          virtualisation.vlans = [ 1 ];

          time.timeZone = "Etc/UTC";

          networking = {
            domain = "foo.bar";
            useDHCP = false;
            firewall.enable = false;
            hosts."10.0.0.1" = [ "server.foo.bar" ];
            hosts."10.0.0.2" = [ "client.foo.bar" ];
          };

          systemd.network.networks."01-eth1" = {
            name = "eth1";
            networkConfig.Address = "10.0.0.1/24";
          };

          security.krb5 = {
            enable = true;
            package = pkgs.heimdal;
            settings = {
              libdefaults.default_realm = "FOO.BAR";

              # Enable extra debug output
              logging = {
                admin_server = "SYSLOG:DEBUG:AUTH";
                default = "SYSLOG:DEBUG:AUTH";
                kdc = "SYSLOG:DEBUG:AUTH";
              };

              realms = {
                "FOO.BAR" = {
                  admin_server = "server.foo.bar";
                  kpasswd_server = "server.foo.bar";
                  kdc = [ "server.foo.bar" ];
                };
              };
            };
          };

          services.kerberos_server = {
            enable = true;
            settings.realms = {
              "FOO.BAR" = {
                acl = [
                  {
                    principal = "kadmin/admin@FOO.BAR";
                    access = "all";
                  }
                  {
                    principal = "alice/admin@FOO.BAR";
                    access = [
                      "add"
                      "cpw"
                      "delete"
                      "get"
                      "list"
                      "modify"
                    ];
                  }
                ];
              };
            };
          };
        };

      client =
        { config, pkgs, ... }:
        {
          imports = [ ../common/user-account.nix ];

          users.users.alice.extraGroups = [ "wheel" ];

          services.getty.autologinUser = "alice";

          virtualisation.vlans = [ 1 ];

          time.timeZone = "Etc/UTC";

          networking = {
            domain = "foo.bar";
            useDHCP = false;
            hosts."10.0.0.1" = [ "server.foo.bar" ];
            hosts."10.0.0.2" = [ "client.foo.bar" ];
          };

          systemd.network.networks."01-eth1" = {
            name = "eth1";
            networkConfig.Address = "10.0.0.2/24";
          };

          security.krb5 = {
            enable = true;
            package = pkgs.heimdal;
            settings = {
              libdefaults.default_realm = "FOO.BAR";

              logging = {
                admin_server = "SYSLOG:DEBUG:AUTH";
                default = "SYSLOG:DEBUG:AUTH";
                kdc = "SYSLOG:DEBUG:AUTH";
              };

              realms = {
                "FOO.BAR" = {
                  admin_server = "server.foo.bar";
                  kpasswd_server = "server.foo.bar";
                  kdc = [ "server.foo.bar" ];
                };
              };
            };
          };
        };
    };

    testScript =
      { nodes, ... }:
      ''
        import string
        import random
        random.seed(0)

        start_all()

        with subtest("Server: initialize realm"):
          # for unit in ["kadmind.service", "kdc.socket", "kpasswdd.socket"]:
          for unit in ["kadmind.service", "kdc.service", "kpasswdd.service"]:
              server.wait_for_unit(unit)

          server.succeed("kadmin -l init --realm-max-ticket-life='8 day' --realm-max-renewable-life='10 day' FOO.BAR")

          for unit in ["kadmind.service", "kdc.service", "kpasswdd.service"]:
              server.systemctl(f"restart {unit}")

        alice_krb_pw = "alice_hunter2"
        alice_old_krb_pw = ""
        alice_krb_admin_pw = "alice_admin_hunter2"

        def random_password():
          password_chars = string.ascii_letters + string.digits + string.punctuation.replace('"', "")
          return "".join(random.choice(password_chars) for _ in range(16))

        with subtest("Server: initialize user principals and keytabs"):
          server.succeed(f'kadmin -l add --password="{alice_krb_admin_pw}" --use-defaults alice/admin')
          server.succeed("kadmin -l ext_keytab --keytab=admin.keytab alice/admin")

          server.succeed(f'kadmin -p alice/admin -K admin.keytab add --password="{alice_krb_pw}" --use-defaults alice')
          server.succeed("kadmin -l ext_keytab --keytab=alice.keytab alice")

        server.wait_for_unit("getty@tty1.service")
        server.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
        server.wait_for_unit("default.target")

        with subtest("Server: initialize host principal with keytab"):
          server.send_chars("sudo ktutil get -p alice/admin host/server.foo.bar\n")
          server.wait_until_tty_matches("1", "password for alice:")
          server.send_chars("${nodes.server.config.users.users.alice.password}\n")
          server.wait_until_tty_matches("1", "alice/admin@FOO.BAR's Password:")
          server.send_chars(f'{alice_krb_admin_pw}\n')
          server.wait_for_file("/etc/krb5.keytab")

          ktutil_list = server.succeed("sudo ktutil list")
          if not "host/server.foo.bar" in ktutil_list:
            exit(1)

          server.send_chars("clear\n")

        client.systemctl("start network-online.target")
        client.wait_for_unit("network-online.target")
        client.wait_for_unit("getty@tty1.service")
        client.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
        client.wait_for_unit("default.target")

        with subtest("Client: initialize host principal with keytab"):
          client.succeed(
            f'echo "{alice_krb_admin_pw}" > pw.txt',
            "kinit -p --password-file=pw.txt alice/admin",
          )

          client.send_chars("sudo ktutil get -p alice/admin host/client.foo.bar\n")
          client.wait_until_tty_matches("1", "password for alice:")
          client.send_chars("${nodes.client.config.users.users.alice.password}\n")
          client.wait_until_tty_matches("1", "alice/admin@FOO.BAR's Password:")
          client.send_chars(f"{alice_krb_admin_pw}\n")
          client.wait_for_file("/etc/krb5.keytab")

          ktutil_list = client.succeed("sudo ktutil list")
          if not "host/client.foo.bar" in ktutil_list:
            exit(1)

          client.send_chars("clear\n")

        with subtest("Client: kinit alice"):
          client.succeed(
            f"echo '{alice_krb_pw}' > pw.txt",
            "kinit -p --password-file=pw.txt alice",
          )
          tickets = client.succeed("klist")
          assert "Principal: alice@FOO.BAR" in tickets
          client.send_chars("clear\n")

        with subtest("Client: kpasswd alice"):
          alice_old_krb_pw = alice_krb_pw
          alice_krb_pw = random_password()
          client.send_chars("kpasswd\n")
          client.wait_until_tty_matches("1", "alice@FOO.BAR's Password:")
          client.send_chars(f"{alice_old_krb_pw}\n", 0.1)
          client.wait_until_tty_matches("1", "New password:")
          client.send_chars(f"{alice_krb_pw}\n", 0.1)
          client.wait_until_tty_matches("1", "Verify password - New password:")
          client.send_chars(f"{alice_krb_pw}\n", 0.1)

          client.wait_until_tty_matches("1", "Success : Password changed")

          client.send_chars("clear\n")

        with subtest("Server: kinit alice"):
          server.succeed(
            "echo 'alice_pw_2' > pw.txt"
            "kinit -p --password-file=pw.txt alice",
          )
          tickets = client.succeed("klist")
          assert "Principal: alice@FOO.BAR" in tickets
          server.send_chars("clear\n")

        with subtest("Server: kpasswd alice"):
          alice_old_krb_pw = alice_krb_pw
          alice_krb_pw = random_password()
          server.send_chars("kpasswd\n")
          server.wait_until_tty_matches("1", "alice@FOO.BAR's Password:")
          server.send_chars(f"{alice_old_krb_pw}\n", 0.1)
          server.wait_until_tty_matches("1", "New password:")
          server.send_chars(f"{alice_krb_pw}\n", 0.1)
          server.wait_until_tty_matches("1", "Verify password - New password:")
          server.send_chars(f"{alice_krb_pw}\n", 0.1)

          server.wait_until_tty_matches("1", "Success : Password changed")

          server.send_chars("clear\n")
      '';

    meta.maintainers = pkgs.heimdal.meta.maintainers;
  }
)
