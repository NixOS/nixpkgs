{ runTest }:
{
  posix = runTest ./posix.nix;
  sftp = runTest ./sftp.nix;
}
