let
  seed = "2151901553968352745";
  rcon-pass = "foobar";
  rcon-port = 43000;
in
{ lib, pkgs, ... }:
{
  name = "minecraft-server";
  meta.maintainers = with lib.maintainers; [ nequissimus ];

  node.pkgsReadOnly = false;

  nodes.server =
    { ... }:
    {
      environment.systemPackages = [ pkgs.mcrcon ];

      nixpkgs.config.allowUnfree = true;

      services.minecraft-server = {
        declarative = true;
        enable = true;
        eula = true;
        serverProperties = {
          enable-rcon = true;
          level-seed = seed;
          level-type = "flat";
          generate-structures = false;
          online-mode = false;
          "rcon.password" = rcon-pass;
          "rcon.port" = rcon-port;
        };
      };

      virtualisation.memorySize = 2047;
    };

  testScript = ''
    server.wait_for_unit("minecraft-server")
    server.wait_for_open_port(${toString rcon-port})
    assert "${seed}" in server.succeed(
        "mcrcon -H localhost -P ${toString rcon-port} -p '${rcon-pass}' -c 'seed'"
    )
    server.succeed("systemctl stop minecraft-server")
  '';
}
