{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/security/secrets/example/common/backend-plain.nix"
    "${modulesPath}/security/secrets/example/common/backend-fail.nix"
    "${modulesPath}/security/secrets"
  ];

  secrets = {
    backends.defaults.store = "plain";
    settings.store.plain.hostDirectory = "/tmp/secrets";
    settings.store.plain.targetDirectory = "/tmp/secrets";
  };
}
