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
    from base64 import b64encode
    from urllib.parse import quote

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

    file_name = "test.txt"
    file_name_base64 = b64encode(file_name.encode('ascii')).decode('ascii')
    file_name_base64_urlencode = quote(file_name_base64)

    machine.succeed(
        f"echo Sample equipment manual > /tmp/{file_name}"
    )

    machine.succeed(
        f"curl -sSf -X 'PUT' -b 'grocy_session={cookie}' "
        + f" 'http://localhost/api/files/equipmentmanuals/{file_name_base64_urlencode}' "
        + "  --header 'Accept: */*' "
        + "  --header 'Content-Type: application/octet-stream' "
        + f" --data-binary '@/tmp/{file_name}' "
    )

    machine.succeed(
        f"curl -sSf -X 'GET' -b 'grocy_session={cookie}' "
        + f" 'http://localhost/api/files/equipmentmanuals/{file_name_base64_urlencode}' "
        + "  --header 'Accept: application/octet-stream' "
        + f" | cmp /tmp/{file_name}"
    )

    machine.shutdown()
  '';
})
