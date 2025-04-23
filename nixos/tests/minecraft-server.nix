let
  seed = "2151901553968352745";
  rcon-pass = "foobar";
  rcon-port = 43000;
in
import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "minecraft-server";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ nequissimus ];
    };

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
          ops = [
            # not real users, just random UUIDs
            {
              name = "TestUser1";
              uuid = "74e97cae-d9c5-483f-a7ab-c90389975955";
              level = 1;
              bypassesPlayerLimit = true;
            }
            {
              name = "TestUser2";
              uuid = "c95bf5db-6181-4787-a44c-cbd23598f262";
            }
          ];
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
)
