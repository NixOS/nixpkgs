{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/security/secrets/example/common/backend-prompt-test.nix"
    "${modulesPath}/security/secrets/example/common//backend-plain.nix"
    "${modulesPath}/security/secrets"
  ];

  secrets = {
    backends.defaults.prompt = "test";
    settings.prompt.test.inputDirectory = ./prompt-inputs;

    backends.defaults.store = "plain";
    settings.store.plain.hostDirectory = "/tmp/secrets-demo";
    settings.store.plain.targetDirectory = "/tmp/secrets-demo";
  };
}
