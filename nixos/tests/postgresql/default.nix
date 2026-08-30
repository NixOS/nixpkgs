{
  runTest,
  pkgs,
}:

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

  importWithArgs =
    path:
    import path {
      inherit runTest genTests;
      inherit (pkgs) lib;
    };
in
{
  # postgresql
  postgresql = importWithArgs ./postgresql.nix;
  postgresql-jit = importWithArgs ./postgresql-jit.nix;
  postgresql-replication = importWithArgs ./postgresql-replication.nix;
  postgresql-wal-receiver = importWithArgs ./postgresql-wal-receiver.nix;
  postgresql-tls-client-cert = importWithArgs ./postgresql-tls-client-cert.nix;

  # extensions
  anonymizer = importWithArgs ./anonymizer.nix;
  pgjwt = importWithArgs ./pgjwt.nix;
  wal2json = importWithArgs ./wal2json.nix;
}
