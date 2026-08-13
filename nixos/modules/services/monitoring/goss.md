# Goss {#module-services-goss}

[goss](https://goss.rocks/) is a YAML based serverspec alternative tool
for validating a server's configuration.

## Basic Usage {#module-services-goss-basic-usage}

A minimal configuration looks like this:

```nix
{
  services.goss = {
    enable = true;

    environment = {
      GOSS_FMT = "json";
      GOSS_LOGLEVEL = "TRACE";
    };

    settings = {
      addr."tcp://localhost:8080" = {
        reachable = true;
        local-address = "127.0.0.1";
      };
      command."check-goss-version" = {
        exec = "${lib.getExe pkgs.goss} --version";
        exit-status = 0;
      };
      dns.localhost.resolvable = true;
      file."/nix" = {
        filetype = "directory";
        exists = true;
      };
      group.root.exists = true;
      kernel-param."kernel.ostype".value = "Linux";
      service.goss = {
        enabled = true;
        running = true;
      };
      user.root.exists = true;
    };
  };
}
```
