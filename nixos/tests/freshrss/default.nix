{ runTest }:

{
  extensions = runTest ./extensions.nix;
  http-auth = runTest ./http-auth.nix;
  pgsql = runTest ./pgsql.nix;
  nginx-sqlite = runTest ./nginx-sqlite.nix;
  caddy-sqlite = runTest ./caddy-sqlite.nix;
}
