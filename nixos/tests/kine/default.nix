{
  pkgs,
  runTest,
  ...
}:

let
  testKine = path: runTest (import path { inherit pkgs; });
in

{
  sqlite = testKine ./sqlite.nix;
  postgres = testKine ./postgres.nix;
  mariadb = testKine ./mariadb.nix;
  mysql = testKine ./mysql.nix;
  nats = testKine ./nats.nix;
}
