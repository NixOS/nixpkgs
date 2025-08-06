{ runTest }:
{
  standard = runTest ./standard.nix;
  with-implicit-systemd-resolved = runTest ./with-implicit-systemd-resolved.nix;
}
