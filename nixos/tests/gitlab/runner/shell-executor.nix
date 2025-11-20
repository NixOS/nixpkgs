{
  runnerConfig,
}:
# This is the runner config for the `nixosConfiguration.services.gitlab-runner.services.X`
{
  services.gitlab-runner.services = {
    description = runnerConfig.desc;
    authenticationTokenConfigFile = runnerConfig.tokenFile;

    executor = "shell";
  };
}
