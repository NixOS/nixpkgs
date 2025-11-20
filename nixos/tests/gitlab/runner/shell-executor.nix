{
  runnerConfig,
}:
# This is the runner config for the `nixosConfiguration.services.gitlab-runner.services.X`
{
  description = runnerConfig.desc;
  authenticationTokenConfigFile = runnerConfig.tokenFile;

  executor = "shell";
}
