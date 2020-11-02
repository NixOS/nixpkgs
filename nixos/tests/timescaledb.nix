{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;

  # Test script from https://docs.timescale.com/latest/getting-started/creating-hypertables
  test-sql = pkgs.writeText "timescaledb-test" ''
    CREATE EXTENSION IF NOT EXISTS timescaledb;
    CREATE TABLE conditions (
      time        TIMESTAMPTZ       NOT NULL,
      location    TEXT              NOT NULL,
      temperature DOUBLE PRECISION  NULL,
      humidity    DOUBLE PRECISION  NULL
    );
    SELECT create_hypertable('conditions', 'time');
    INSERT INTO conditions(time, location, temperature, humidity)
      VALUES (NOW(), 'office', 70.0, 50.0);
    SELECT * FROM conditions ORDER BY time DESC LIMIT 100;
  '';
in makeTest {
  name = "timescaledb-test";
  meta = with pkgs.stdenv.lib.maintainers; { maintainers = [ chkno ]; };

  machine = {
    services.postgresql = {
      enable = true;
      extraPlugins = [ pkgs.timescaledb ];
      settings.shared_preload_libraries = "timescaledb";
    };
  };

  testScript = ''
    machine.wait_for_unit("postgresql")
    machine.succeed(
        "cat ${test-sql} | sudo -u postgres psql",
        '[[ "$(sudo -u postgres psql postgres -tAc "SELECT * FROM conditions ORDER BY time DESC LIMIT 100")" == *"|office|70|50" ]]',
    )
  '';

}
