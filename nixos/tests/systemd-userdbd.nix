import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "systemd-userdbd";
  nodes.machine = { config, pkgs, ... }: {
    services.userdbd.enable = true;

    users.users.test-user-nss = {
      isNormalUser = true;
    };

    environment.etc."userdb/test-user-dropin.user".text = builtins.toJSON {
      userName = "test-user-dropin";
    };

    environment.systemPackages = with pkgs; [ libvarlink ];
  };
  testScript = ''
    import json
    from shlex import quote

    def getUserRecord(name):
      Interface = "unix:/run/systemd/userdb/io.systemd.Multiplexer/io.systemd.UserDatabase"
      payload = json.dumps({
        "service": "io.systemd.Multiplexer",
        "userName": name
      })
      return json.loads(machine.succeed(f"varlink call {Interface}.GetUserRecord {quote(payload)}"))

    machine.wait_for_unit("systemd-userdbd.socket")
    getUserRecord("test-user-nss")
    getUserRecord("test-user-dropin")
  '';
})
