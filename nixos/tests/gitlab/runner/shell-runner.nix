{
  runnerConfig,
}:
# This is the runner config for the `nixosConfiguration.services.gitlab-runner.services.X`
{
  services.gitlab-runner.services.shell-runner = {
    description = runnerConfig.desc;
    authenticationTokenConfigFile = runnerConfig.tokenFile;

    executor = "shell";
  };
}
