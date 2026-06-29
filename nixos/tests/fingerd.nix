{ lib, ... }:
let
  testUser = "alice";
  testPlan = "NixOS fingerd smoke test";
  port = 1079;
in
{
  name = "fingerd";
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];

      users.users.${testUser} = {
        isNormalUser = true;
        createHome = true;
        description = "Alice Example";
      };

      services.fingerd = {
        enable = true;
        listen = ":${toString port}";
        aliasFile = null;
      };

      systemd.services.fingerd-test-data = {
        wantedBy = [ "multi-user.target" ];
        before = [ "fingerd.service" ];
        serviceConfig.Type = "oneshot";
        script = ''
          cat > /home/${testUser}/.plan <<'EOF'
          ${testPlan}
          EOF
          chown ${testUser} /home/${testUser}/.plan
          chmod 0644 /home/${testUser}/.plan
        '';
      };

      environment.systemPackages = [
        (pkgs.writeScriptBin "test-finger" ''
          #!${pkgs.python3}/bin/python3

          import socket

          with socket.create_connection(("127.0.0.1", ${toString port}), timeout=5) as sock:
              sock.sendall(b"${testUser}\r\n")
              data = bytearray()
              while True:
                  chunk = sock.recv(4096)
                  if not chunk:
                      break
                  data.extend(chunk)

          print(data.decode("utf-8", errors="replace"))
        '')
      ];
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("fingerd.service")
    machine.wait_for_open_port(${toString port})

    machine.succeed("test-finger | grep -F '${testUser}'")
    machine.succeed("test-finger | grep -F '${testPlan}'")
  '';
}
