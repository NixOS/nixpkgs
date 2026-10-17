{
  name = "rsync";

  nodes.machine = {
    users.users.test.isNormalUser = true;

    services.rsync = {
      enable = true;
      jobs = {
        root = {
          sources = [ "/root/src/" ];
          destination = "/root/dst";
          settings = {
            archive = true;
            delete = true;
            mkpath = true;
          };
          timerConfig = {
            OnCalendar = "daily";
            Persistent = false;
          };
          inhibit = [ "sleep" ];
        };
        user = {
          sources = [ "/home/test/src/" ];
          destination = "/home/test/dst";
          settings = {
            archive = true;
            delete = true;
            mkpath = true;
          };
          timerConfig = {
            OnCalendar = "daily";
            Persistent = false;
          };
          user = "test";
          group = "users";
        };
      };
    };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("multi-user.target")

    machine.succeed("mkdir --parents /root/src")
    machine.succeed("echo test data > /root/src/file.txt")
    machine.start_job("rsync-job-root.service")
    machine.succeed("""[[ 'test data' == "$(< /root/dst/file.txt)" ]]""")

    machine.succeed("mkdir --parents /home/test/src")
    machine.succeed("echo test data > /home/test/src/file.txt")
    machine.start_job("rsync-job-user.service")
    machine.succeed("""[[ 'test data' == "$(< /home/test/dst/file.txt)" ]]""")

    machine.wait_for_unit("timers.target")
    machine.require_unit_state("rsync-job-root.timer", "active")
    machine.require_unit_state("rsync-job-user.timer", "active")

    machine.shutdown()
  '';
}
