{ pkgs, ... }:
{
  name = "rmfakecloud";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ martinetd ];
  };

  nodes.machine = {
    services.rmfakecloud = {
      enable = true;
      storageUrl = "https://local.appspot.com";
    };
  };

  testScript = ''
    machine.wait_for_unit("rmfakecloud.service")
    machine.wait_for_open_port(3000)

    # first login creates user
    login_token = machine.succeed("""
      curl -sSf -b cookie -c cookie -H "Content-Type: application/json" \
        -d'{"email":"test","password":"test"}' -X POST \
        http://localhost:3000/ui/api/login
    """)

    # subsequent different pass or mail should fail, but same login works
    machine.fail("""
      curl -sSf -H "Content-Type: application/json" \
        -d'{"email":"test","password":"test2"}' -X POST \
        http://localhost:3000/ui/api/login
    """)
    machine.fail("""
      curl -sSf -H "Content-Type: application/json" \
        -d'{"email":"test2","password":"test"}' -X POST
        http://localhost:3000/ui/api/login
    """)
    machine.succeed("""
      curl -sSf -H "Content-Type: application/json" \
        -d'{"email":"test","password":"test"}' -X POST \
        http://localhost:3000/ui/api/login
    """)

    # can get code from cookie or bearer
    machine.succeed("""
      curl -sSf -b cookie -c cookie http://localhost:3000/ui/api/newcode
    """)
    newcode = machine.succeed(f"""
      curl -sSf -H "Authorization: Bearer {login_token}" \
        http://localhost:3000/ui/api/newcode
    """).strip('"')

    # ... but not junk
    machine.fail(f"""
      curl -sSf -H "Authorization: Bearer abc{login_token}" \
          http://localhost:3000/ui/api/newcode
    """)

    # can connect "device" with said code
    machine.succeed(f"""
      curl -sSf -d '{{"code":"{newcode}", "deviceDesc": "desc", "deviceID":"rm100-123"}}' \
        http://localhost:3000/token/json/2/device/new
    """)

    # for future improvements
    machine.log(machine.execute("systemd-analyze security rmfakecloud.service")[1])
  '';
}
