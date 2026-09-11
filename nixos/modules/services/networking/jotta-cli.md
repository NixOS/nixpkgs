# Jottacloud Command-line Tool {#module-services-jotta-cli}

The [Jottacloud Command-line Tool](https://docs.jottacloud.com/en/articles/1436834-jottacloud-command-line-tool) is a headless [Jottacloud](https://jottacloud.com) client.

## Quick Start {#module-services-jotta-cli-quick-start}

```nix
{ services.jotta-cli.enable = true; }
```

This adds `jotta-cli` to `environment.systemPackages` and starts a user service that runs `jottad` with the default options.

## Example Configuration {#module-services-jotta-cli-example-configuration}

```nix
{
  services.jotta-cli = {
    enable = true;
    options = [ "slow" ];
    package = pkgs.jotta-cli;
  };
}
```

This uses `jotta-cli` and `jottad` from the `pkgs.jotta-cli` package and starts `jottad` in low memory mode.

`jottad` is also added to `environment.systemPackages`, so `jottad --help` can be used to explore options.
