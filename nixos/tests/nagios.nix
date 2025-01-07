import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "nagios";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ symphorien ];
    };

    nodes.machine =
      { lib, ... }:
      let
        writer = pkgs.writeShellScript "write" ''
          set -x
          echo "$@"  >> /tmp/notifications
        '';
      in
      {
        # tested service
        services.sshd.enable = true;
        # nagios
        services.nagios = {
          enable = true;
          # make state transitions faster
          extraConfig.interval_length = "5";
          objectDefs =
            (map (x: "${pkgs.nagios}/etc/objects/${x}.cfg") [
              "templates"
              "timeperiods"
              "commands"
            ])
            ++ [
              (pkgs.writeText "objects.cfg" ''
                # notifications are written to /tmp/notifications
                define command {
                command_name notify-host-by-file
                command_line ${writer} "$HOSTNAME is $HOSTSTATE$"
                }
                define command {
                command_name notify-service-by-file
                command_line ${writer} "$SERVICEDESC$ is $SERVICESTATE$"
                }

                # nagios boilerplate
                define contact {
                contact_name                    alice
                alias                           alice
                host_notifications_enabled      1
                service_notifications_enabled   1
                service_notification_period     24x7
                host_notification_period        24x7
                service_notification_options    w,u,c,r,f,s
                host_notification_options       d,u,r,f,s
                service_notification_commands   notify-service-by-file
                host_notification_commands      notify-host-by-file
                email                           foo@example.com
                }
                define contactgroup {
                contactgroup_name   admins
                alias               Admins
                members alice
                }
                define hostgroup{
                hostgroup_name  allhosts
                alias  All hosts
                }

                # monitored objects
                define host {
                use         generic-host
                host_name   localhost
                alias       localhost
                address     localhost
                hostgroups  allhosts
                contact_groups admins
                # make state transitions faster.
                max_check_attempts 2
                check_interval 1
                retry_interval 1
                }
                define service {
                use                 generic-service
                host_name           localhost
                service_description ssh
                check_command       check_ssh
                # make state transitions faster.
                max_check_attempts 2
                check_interval 1
                retry_interval 1
                }
              '')
            ];
        };
      };

    testScript =
      { ... }:
      ''
        with subtest("ensure sshd starts"):
            machine.wait_for_unit("sshd.service")


        with subtest("ensure nagios starts"):
            machine.wait_for_file("/var/log/nagios/current")


        def assert_notify(text):
            machine.wait_for_file("/tmp/notifications")
            real = machine.succeed("cat /tmp/notifications").strip()
            print(f"got {real!r}, expected {text!r}")
            assert text == real


        with subtest("ensure we get a notification when sshd is down"):
            machine.succeed("systemctl stop sshd")
            assert_notify("ssh is CRITICAL")


        with subtest("ensure tests can succeed"):
            machine.succeed("systemctl start sshd")
            machine.succeed("rm /tmp/notifications")
            assert_notify("ssh is OK")
      '';
  }
)
