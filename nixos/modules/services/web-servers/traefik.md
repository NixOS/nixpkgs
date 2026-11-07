# Traefik {#module-services-traefik}

[Traefik][upstream-1] is an open-source, cloud-native reverse proxy configured using the {option}`services.traefik` option set.

## Basic Usage {#module-services-traefik-usage}

A key feature of Traefik is that the reverse proxy configuration is split into two:
1. [**Install configuration**](#module-services-traefik-usage-install), previously "static" configuration
2. [**Routing configuration**](#module-services-traefik-usage-routing), previously "dynamic" configuration

The [upstream documentation][upstream-2] has a detailed overview on the difference between both configuration types.

## Install Configuration {#module-services-traefik-usage-install}

::: {.note}
This was formerly known as the "static" configuration
:::

Install configuration is controlled by the {option}`services.traefik.install` option set.
This defines parameters that require Traefik to restart when changed, including:
- Entry points
- Providers
- API/dashboard settings
- Logging levels


### Install Configuration: file {#module-services-traefik-usage-install-file}

{option}`services.traefik.install.file` allows you to pass a path to a file containing a Traefik configuration:

```nix
{
  services.traefik.install.file = "/etc/traefik/install.yml";
}
```

By default, this is set to a JSON file generated from {option}`services.traefik.install.settings`.

### Install Configuration: settings {#module-services-traefik-usage-install-settings}

{option}`services.traefik.install.settings` allows you to declare the install configuration directly in Nix syntax:

```nix
{
  services.traefik.install.settings = {
    log.level = "DEBUG";
    global.checkNewVersion = false;
    entryPoints."web" = {
      address = ":80";
      asDefault = true;
    };
  };
}
```

## Routing Configuration {#module-services-traefik-usage-routing}

::: {.note}
This was formerly known as the "dynamic" configuration
:::

Routing configuration is controlled by the {option}`services.traefik.routing` option set.

This involves elements that can be updated without restarting Traefik, such as:
- Routers
- Services
- Middlewares

### Routing Configuration: file {#module-services-traefik-usage-routing-file}

{option}`services.traefik.routing.file` allows you to pass a path to a file containing routing configuration:

```nix
{
  services.traefik.routing.file = "/etc/traefik/routing.yml";
}
```

By default, this is set to the JSON file stored in {option}`services.traefik.routing.settingsDrv`

### Routing Configuration: settings {#module-services-traefik-usage-routing-settings}

{option}`services.traefik.routing.settings` allows you to declare routing configuration directly in Nix syntax:
```nix
{
  services.traefik.routing.settings = {
    http.routers."dashboard" = {
      service = "api@internal";
      rule = "Host(`traefik.example.com`)";
    };
  };
}
```

### Routing Configuration: dir {#module-services-traefik-usage-routing-dir}

::: {.warning}
Files in this directory matching the glob `__nixos-*` (reserved for Nix-managed routing configurations) will be deleted as part of
`systemd-tmpfiles-resetup.service`, _**regardless of their origin.**_
:::

{option}`services.traefik.routing.dir` allows you to set a directory containing multiple routing configuration files:

```nix
{
  services.traefik.routing.dir = "/etc/traefik/routing";
}
```

These can include imperative and [declaratively configured](#module-services-traefik-usage-routing-extrafiles) files.

### Routing Configuration: extraFiles {#module-services-traefik-usage-routing-extrafiles}

{option}`services.traefik.routing.extraFiles.<name>.settings` option allows you to create multiple named configuration submodules:

```nix
{
  services.traefik.routing.extraFiles = {
    "dashboard".settings = {
      http.routers."dashboard" = {
        service = "api@internal";
        rule = "Host(`traefik.example.com`)";
        middlewares = [ "private-only" ];
      };
    };
    "middlewares".settings = {
      http.middlewares."private-only".ipallowlist.sourcerange = [
        "192.168.0.0/16"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "127.0.0.0/8"
      ];
    };
  };
}
```

These accept the same options as {option}`services.traefik.routing.settings`.

::: {.note}
- If {option}`services.traefik.routing.dir` **_is_** set:
  - A JSON file will be generated from each submodule and symlinked there
- If {option}`services.traefik.routing.dir` is **_not_** set, and {option}`services.traefik.routing.settings` **_is_**:
  - all `settings` sets will be merged to form {option}`services.traefik.routing.settingsDrv`
    - This is to allow NixOS modules to create `traefik.enable` options compatible with both `routing.extraFiles` and `routing.settings`
:::

{option}`services.traefik.routing.extraFiles` has a number of benefits compared to {option}`services.traefik.routing.settings`:
- `extraFiles` allows mixing imperative and declarative routing configuration seamlessly
- Since `extraFiles` are loaded from {option}`services.traefik.routing.dir` continually, the Traefik daemon does not need to be restarted for configuration changes to apply
  - This allows long lived connections (such as VPN traffic) to remain uninterrupted
- `extraFiles` can be manipulated at runtime without the need to rebuild the system. Applications could include:
  - Taking down a bad service by deleting the symlink in {option}`services.traefik.routing.dir`
    - Due to a [limitation in traefik][routing-limit], an error in *any* routing configuration will cause the entire `directory` provider to be ignored
      - _The bad configuration symlink can be removed to restore service until the system can be rebuilt_
  - Taking a service down for security reasons
    - _Deleting a configuration symlink is often quicker than rebuilding the system_
  - Editing service configurations for rapid iteration
    - _Copy the file from the nix store and replace the symlink with it_
  - Making temporary changes to the routing configuration that will be discarded upon the next system activation
    - _Ensure any files involved have the prefix `__nixos-`. These will be deleted before the new configurations are linked_


## Environment Files {#module-services-traefik-environment}

Environment files can be used to provision secrets for ACME/Let's Encrypt and other certificate setups.
See the [upstream documentation][upstream-4] for more information on passing ACME secrets for DNS-01 challenges.

Although the Traefik module offers the {option}`services.traefik.environmentFiles`
option to set up environment variables for the running server, *it is not recommended to use them as the install configuration source.*
The configuration methods are mutually exclusive, and evaluated in the following order:

- In a configuration file
- In the command-line arguments
- As environment variables



## Migrating to 26.11 {#module-services-traefik-migrating-to-26.11}

The Traefik module now features new ways to deploy the routing and install configuration, which were previously called dynamic and static configuration. For a simple migration, move your existing static and dynamic configurations to `services.traefik.install` and `services.traefik.routing` respectively:

- `services.traefik.staticConfigFile` -> `services.traefik.install.file`
- `services.traefik.staticConfigOptions` -> `services.traefik.install.settings`
- `services.traefik.dynamicConfigFile` -> `services.traefik.routing.file`
- `services.traefik.dynamicConfigOptions` -> `services.traefik.routing.settings`

The option `useEnvSubst` has been removed, as using environment variables to store secrets is already supported by the {option}`services.traefik.environmentFiles`. Please open an issue if this incompatible with your setup.

A new option submodule, `services.traefik.routing.extraFiles.<name>`, is now available. In conjunction with {option}`services.traefik.routing.dir`, this allows you to group settings into files that are linked to Traefik's `providers.file.directory`. This allows you to mix declarative and imperative configuration, and means that changes in the routing configuration can occur without restarting the Traefik daemon. Please see the [usage](#module-services-traefik-usage) section for a thorough description of the new options.

[upstream-1]: https://traefik.io/traefik
[upstream-2]: https://doc.traefik.io/traefik/getting-started/configuration-overview
[upstream-3]: https://plugins.traefik.io/plugins
[routing-limit]: https://github.com/traefik/traefik/issues/10890
[upstream-4]: https://doc.traefik.io/traefik/https/acme/#providers
