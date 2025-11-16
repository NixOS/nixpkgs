{
  config,
  lib,
  runnerTokenFile,
}:
{
  description = "NixOS Shell Executor";
  authenticationTokenConfigFile = runnerTokenFile;
  executor = "shell";
}
