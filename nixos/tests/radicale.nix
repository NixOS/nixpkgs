import ./make-test-python.nix (
  { lib, pkgs, ... }:

  let
    user = "someuser";
    password = "some_password";
    port = "5232";
    filesystem_folder = "/data/radicale";

    cli = "${lib.getExe pkgs.calendar-cli} --caldav-user ${user} --caldav-pass ${password}";
  in
  {
    name = "radicale3";
    meta.maintainers = with lib.maintainers; [ dotlambda ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.radicale = {
          enable = true;
          settings = {
            auth = {
              type = "htpasswd";
              htpasswd_filename = "/etc/radicale/users";
              htpasswd_encryption = "bcrypt";
            };
            storage = {
              inherit filesystem_folder;
              hook = "git add -A && (git diff --cached --quiet || git commit -m 'Changes by '%(user)s)";
            };
            logging.level = "info";
          };
          rights = {
            principal = {
              user = ".+";
              collection = "{user}";
              permissions = "RW";
            };
            calendars = {
              user = ".+";
              collection = "{user}/[^/]+";
              permissions = "rw";
            };
          };
        };
        systemd.services.radicale.path = [ pkgs.git ];
        environment.systemPackages = [ pkgs.git ];
        systemd.tmpfiles.rules = [ "d ${filesystem_folder} 0750 radicale radicale -" ];
        # WARNING: DON'T DO THIS IN PRODUCTION!
        # This puts unhashed secrets directly into the Nix store for ease of testing.
        environment.etc."radicale/users".source = pkgs.runCommand "htpasswd" { } ''
          ${pkgs.apacheHttpd}/bin/htpasswd -bcB "$out" ${user} ${password}
        '';
      };
    testScript = ''
      machine.wait_for_unit("radicale.service")
      machine.wait_for_open_port(${port})

      machine.succeed("sudo -u radicale git -C ${filesystem_folder} init")
      machine.succeed(
          "sudo -u radicale git -C ${filesystem_folder} config --local user.email radicale@example.com"
      )
      machine.succeed(
          "sudo -u radicale git -C ${filesystem_folder} config --local user.name radicale"
      )

      with subtest("Test calendar and event creation"):
          machine.succeed(
              "${cli} --caldav-url http://localhost:${port}/${user} calendar create cal"
          )
          machine.succeed("test -d ${filesystem_folder}/collection-root/${user}/cal")
          machine.succeed('test -z "$(ls ${filesystem_folder}/collection-root/${user}/cal)"')
          machine.succeed(
              "${cli} --caldav-url http://localhost:${port}/${user}/cal calendar add 2021-04-23 testevent"
          )
          machine.succeed('test -n "$(ls ${filesystem_folder}/collection-root/${user}/cal)"')
          (status, stdout) = machine.execute(
              "sudo -u radicale git -C ${filesystem_folder} log --format=oneline | wc -l"
          )
          assert status == 0, "git log failed"
          assert stdout == "3\n", "there should be exactly 3 commits"

      with subtest("Test rights file"):
          machine.fail(
              "${cli} --caldav-url http://localhost:${port}/${user} calendar create sub/cal"
          )
          machine.fail(
              "${cli} --caldav-url http://localhost:${port}/otheruser calendar create cal"
          )

      with subtest("Test web interface"):
          machine.succeed("curl --fail http://${user}:${password}@localhost:${port}/.web/")

      with subtest("Test security"):
          output = machine.succeed("systemd-analyze security radicale.service")
          machine.log(output)
          assert output[-9:-1] == "SAFE :-}"
    '';
  }
)
