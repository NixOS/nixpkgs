import ./make-test-python.nix ({ pkgs, lib, ...}:

with pkgs; {
  name = "pgsidekick";
  meta.maintainers = with lib.maintainers; [ ggpeti ];

  nodes.master = { ... }: {
    services.postgresql = {
      enable = true;
      initialScript = pkgs.writeScript "init.sql" ''
        CREATE TABLE test (a integer, b text);

        CREATE OR REPLACE FUNCTION new_row_notify() RETURNS TRIGGER AS $$
        BEGIN
          PERFORM pg_notify('test_channel'::TEXT, row_to_json(NEW)::TEXT);
          RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER test_trg AFTER INSERT ON test FOR EACH ROW EXECUTE PROCEDURE new_row_notify();
      '';
    };
    systemd.services.listener = {
      wantedBy = [ "multi-user.target" ];
      after = [ "postgresql.service" ];
      serviceConfig.User = "postgres";
      path = with pkgs; [ pgsidekick ];
      script = "pglisten --listen=test_channel --dbname=postgres";
    };
  };

  testScript = { nodes, ... }:
  let
    sqlSU = "${nodes.master.config.services.postgresql.superUser}";
  in
  ''
    start_all()
    master.wait_for_unit("listener")
    master.succeed(
        "${pkgs.sudo}/bin/sudo -u ${sqlSU} ${pkgs.postgresql}/bin/psql -c \"INSERT INTO test VALUES (1, 'a')\""
    )
    master.wait_until_succeeds('journalctl -u listener -b | grep \'{"a":1,"b":"a"}\' ')
  '';
})
