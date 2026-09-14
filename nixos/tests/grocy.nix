{ pkgs, ... }:
{
  name = "grocy";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      diogotcorreia
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
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

    # This establishes _something_
    machine.succeed("curl -sSf http://localhost")
    # The second request creates the database, unsure why both are required
    machine.succeed("curl -sSf http://localhost/")

    machine.succeed(
        "curl --cookie-jar cookies.txt -sSf -X POST http://localhost/login -d 'username=admin&password=admin'"
    )

    machine.succeed(
        "curl -sSf -X POST http://localhost/api/objects/tasks --cookie cookies.txt "
        + '-d \'{"assigned_to_user_id":1,"name":"Test Task","due_date":"1970-01-01"}\'''
        + " --header 'Content-Type: application/json'"
    )

    task_name = machine.succeed(
        "curl -sSf http://localhost/api/tasks --cookie cookies.txt --header 'Accept: application/json' | jq '.[].name' | xargs echo | perl -pe 'chomp'"
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
        "curl -sSf -X 'PUT' --cookie cookies.txt "
        + f" 'http://localhost/api/files/equipmentmanuals/{file_name_base64_urlencode}' "
        + "  --header 'Accept: */*' "
        + "  --header 'Content-Type: application/octet-stream' "
        + f" --data-binary '@/tmp/{file_name}' "
    )

    machine.succeed(
        "curl -sSf -X 'GET' --cookie cookies.txt "
        + f" 'http://localhost/api/files/equipmentmanuals/{file_name_base64_urlencode}' "
        + "  --header 'Accept: application/octet-stream' "
        + f" | cmp /tmp/{file_name}"
    )

    machine.shutdown()
  '';
}
