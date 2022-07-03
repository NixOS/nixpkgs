import ./make-test-python.nix ({ pkgs, ... }: {
  name = "grocy";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes.machine = { pkgs, ... }: {
    services.grocy = {
      enable = true;
      hostName = "localhost";
      nginx.enableSSL = false;
    };
    environment.systemPackages = [ pkgs.jq ];
  };

  testScript = ''
    machine.start()
    machine.wait_for_open_port(80)
    machine.wait_for_unit("multi-user.target")

    machine.succeed("curl -sSf http://localhost")

    machine.succeed(
        "curl -c cookies -sSf -X POST http://localhost/login -d 'username=admin&password=admin'"
    )

    cookie = machine.succeed(
        "grep -v '^#' cookies | awk '{ print $7 }' | sed -e '/^$/d' | perl -pe 'chomp'"
    )

    machine.succeed(
        f"curl -sSf -X POST http://localhost/api/objects/tasks -b 'grocy_session={cookie}' "
        + '-d \'{"assigned_to_user_id":1,"name":"Test Task","due_date":"1970-01-01"}\'''
        + " --header 'Content-Type: application/json'"
    )

    task_name = machine.succeed(
        f"curl -sSf http://localhost/api/tasks -b 'grocy_session={cookie}' --header 'Accept: application/json' | jq '.[].name' | xargs echo | perl -pe 'chomp'"
    )

    assert task_name == "Test Task"

    machine.succeed("curl -sSI http://localhost/api/tasks 2>&1 | grep '401 Unauthorized'")

    machine.shutdown()
  '';
})
