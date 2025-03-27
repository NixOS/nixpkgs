{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };

let
  inherit (pkgs.lib)
    recurseIntoAttrs
    filterAttrs
    mapAttrs
    const
    ;
  genTests =
    {
      makeTestFor,
      filter ? (_: _: true),
    }:
    recurseIntoAttrs (
      mapAttrs (const makeTestFor) (filterAttrs filter pkgs.postgresqlVersions)
      // {
        passthru.override = makeTestFor;
      }
    );

  importWithArgs = path: import path { inherit pkgs makeTest genTests; };
in
{
  # postgresql
  postgresql = importWithArgs ./postgresql.nix;
  postgresql-jit = importWithArgs ./postgresql-jit.nix;
  postgresql-wal-receiver = importWithArgs ./postgresql-wal-receiver.nix;
  postgresql-tls-client-cert = importWithArgs ./postgresql-tls-client-cert.nix;

  # extensions
  anonymizer = importWithArgs ./anonymizer.nix;
  citus = importWithArgs ./citus.nix;
  pgjwt = importWithArgs ./pgjwt.nix;
  pgvecto-rs = importWithArgs ./pgvecto-rs.nix;
  timescaledb = importWithArgs ./timescaledb.nix;
  tsja = importWithArgs ./tsja.nix;
  wal2json = importWithArgs ./wal2json.nix;
}
