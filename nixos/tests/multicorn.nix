import ./make-test-python.nix ({ pkgs, ...} :
let
  test-sql1 = pkgs.writeText "postgresql-test" ''
    \set ON_ERROR_STOP on
    CREATE SERVER multicorn_imap FOREIGN DATA WRAPPER multicorn options (wrapper 'multicorn.imapfdw.ImapFdw');
  '';
  test-sql2 = pkgs.writeText "postgresql-test" ''
    \set ON_ERROR_STOP on
    CREATE SERVER csv_srv FOREIGN DATA WRAPPER multicorn options (wrapper 'multicorn.csvfdw.CsvFdw');
  '';
in
{
  name = "multicorn";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bbigras ];
  };

  nodes = {
    master =
      { pkgs, ... }:

      {
        services.postgresql = let mypg = pkgs.postgresql; in {
            enable = true;
            package = mypg;
            extraPlugins = with mypg.pkgs; [
              multicorn
            ];
        };
      };
  };

  testScript = ''
    start_all()
    master.wait_for_unit("postgresql")
    master.sleep(10)  # Hopefully this is long enough!!
    master.succeed("sudo -u postgres psql -c 'CREATE EXTENSION multicorn;'")
    master.succeed(
        "cat ${test-sql1} | sudo -u postgres psql"
    )
    master.succeed(
        "cat ${test-sql2} | sudo -u postgres psql"
    )
  '';
})
