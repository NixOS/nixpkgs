import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "minetest-with-packages";
  meta = with lib.maintainers; { maintainers = [ fgaz ]; };

  nodes.machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    virtualisation.memorySize = 2047;

    services.xserver.enable = true;
    sound.enable = true;
    environment.systemPackages = [
      (pkgs.minetestWithPackages (mtps: [ mtps.contentDB.Wuzzy.mineclone2 ]))
    ];
  };

  testScript = { nodes, ... }:
    let
      world = pkgs.writeText "world.mt" ''
        mod_storage_backend = sqlite3
        auth_backend = sqlite3
        player_backend = sqlite3
        backend = sqlite3
        gameid = mineclone2
        world_name = mcl_test
      '';
      map_meta = pkgs.writeText "map_meta.txt" ''
        mg_name = v7
        seed = 0
        [end_of_params]
      '';
    in ''
      # Set up a basic mineclone2 world
      machine.succeed("mkdir -p ~/.minetest/worlds/mcl_test")
      machine.copy_from_host("${world}", "/root/.minetest/worlds/mcl_test/world.mt")
      machine.copy_from_host("${map_meta}", "/root/.minetest/worlds/mcl_test/map_meta.txt")

      machine.wait_for_x()
      # Add a dummy sound card, or we'll have a sound error in the log
      machine.execute("modprobe snd-dummy")

      # Test clean shutdown (on SIGTERM).
      # We have to check for "ERROR" strings because minetest exits with code 0
      # on certain errors (such as missing world).
      machine.succeed("timeout --preserve-status -k60 120 minetest --go --worldname mcl_test 2>&1 | tee output")
      machine.succeed('[ -z "$(grep ERROR output)" ]')

      # Take a screenshot of the game.
      machine.execute("minetest --go --worldname mcl_test >&2 &")
      machine.wait_for_window(r"Singleplayer")
      machine.sleep(10)
      machine.screenshot("screen")
    '';
})
