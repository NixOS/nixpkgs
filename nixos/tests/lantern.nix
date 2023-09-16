import ./make-test-python.nix ({ pkgs, ... }: {
  name = "lantern";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ moody ];
  };

  nodes = {
    master =
      { pkgs, ... }:

      {
        services.postgresql = let mypg = pkgs.postgresql; in {
          enable = true;
          package = mypg;
          extraPlugins = with mypg.pkgs; [
            lantern
          ];
        };
      };
  };

  testScript = ''
    start_all()
    master.wait_for_unit("postgresql")
    master.sleep(10)  # Hopefully this is long enough!!
    master.succeed("sudo -u postgres psql -c 'CREATE EXTENSION lantern;'")
    master.succeed("sudo -u postgres psql -c 'CREATE TABLE small_world (id integer, vector real[3]);'")
    master.succeed("sudo -u postgres psql -c \"INSERT INTO small_world (id, vector) VALUES (0, '{0,0,0}'), (1, '{0,0,1}');\"")
    master.succeed("sudo -u postgres psql -c 'CREATE INDEX ON small_world USING hnsw (vector);'")
    master.succeed("sudo -u postgres psql -c 'SET enable_seqscan = false; SELECT id, l2sq_dist(vector, ARRAY[0,0,0]) AS dist FROM small_world ORDER BY vector <-> ARRAY[0,0,0] LIMIT 1;'")
  '';
})
