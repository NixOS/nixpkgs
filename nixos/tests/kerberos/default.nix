{
  pkgs,
  runTest,
}:
{
  mit = runTest ./mit.nix;
  heimdal = runTest ./heimdal.nix;
  ldap = import ./ldap { inherit pkgs runTest; };
}
