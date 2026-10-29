{ lib, pkgs, ... }:
let
  seed = "2151901553968352745";
  rcon-pass = "foobar";
  rcon-port = 25575;
in
{
  name = "pumpkin";

  containers.machine = {
    environment.systemPackages = [ pkgs.mcrcon ];

    systemd.tmpfiles.rules = [
      "f /root/rcon-password 0400 root root - ${rcon-pass}"
    ];

    services.pumpkin = {
      enable = true;
      settings = {
        inherit seed;
        bedrock.enabled = false;
        networking.rcon = {
          enabled = true;
          address = "0.0.0.0:${toString rcon-port}";
          passwordFile = "/root/rcon-password";
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("pumpkin")
    machine.wait_for_open_port(25565)
    machine.wait_for_open_port(${toString rcon-port})
    assert "${seed}" in machine.succeed(
        "mcrcon -H localhost -P ${toString rcon-port} -p '${rcon-pass}' -c 'seed'"
    )
    machine.systemctl("stop pumpkin")
    machine.wait_until_fails("systemctl is-active --quiet pumpkin")
  '';

  meta.maintainers = with lib.maintainers; [
    DerGrumpf
    jk
  ];
}
