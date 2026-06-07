{ lib, runTest }:
lib.recurseIntoAttrs {
  basic = runTest ./basic.nix;
  e2e = runTest ./e2e.nix;
  postgres = runTest ./postgres.nix;
  s3-backups = runTest ./s3-backups.nix;
}
