# Suwayomi-Server {#module-services-suwayomi-server}

A free and open source manga reader server that runs extensions built for Tachiyomi.

## Basic usage {#module-services-suwayomi-server-basic-usage}

By default, the module will execute Suwayomi-Server backend and serve the web UI:

```nix
{ ... }:

{
  services.suwayomi-server = {
    enable = true;
  };
}
```

It runs in the systemd service named `suwayomi-server` in the data directory `/var/lib/suwayomi-server`.

You can change the default parameters with some other parameters:
```nix
{ ... }:

{
  services.suwayomi-server = {
    enable = true;

    dataDir = "/var/lib/suwayomi"; # Default is "/var/lib/suwayomi-server"
    openFirewall = true;

    settings = {
      server.port = 4567;
    };
  };
}
```

If you want to create a desktop icon, you can activate the system tray option:

```nix
{ ... }:

{
  services.suwayomi-server = {
    enable = true;

    dataDir = "/var/lib/suwayomi"; # Default is "/var/lib/suwayomi-server"
    openFirewall = true;

    settings = {
      server.port = 4567;
      server.enableSystemTray = true;
    };
  };
}
```

## Basic authentication {#module-services-suwayomi-server-basic-auth}

You can configure a basic authentication to the web interface with:

```nix
{ ... }:

{
  services.suwayomi-server = {
    enable = true;

    openFirewall = true;

    settings = {
      server.port = 4567;
      server = {
        authMode = "basic_auth";
        authUsername = "username";

        # NOTE: this option is a NixOS option only
        # and doesn't exist in the upstream configuration
        authPasswordFile = "/run/secrets/your-secret-password-file";
      };
    };
  };
}
```

## Extra configuration {#module-services-suwayomi-server-extra-config}

Not all the configuration options are available directly in this module, but you can add the other options of suwayomi-server with:

```nix
{ ... }:

{
  services.suwayomi-server = {
    enable = true;

    openFirewall = true;

    settings = {
      server = {
        port = 4567;
        autoDownloadNewChapters = false;
        maxSourcesInParallel = 6;
        extensionRepos = [
          "https://raw.githubusercontent.com/MY_ACCOUNT/MY_REPO/repo/index.min.json"
        ];
      };
    };
  };
}
```

## Migrating the data directory {#module-services-suwayomi-migrating-data-directory}

The app's data directory has changed to reflect `services.suwayomi-server.dataDir` accurately.
Previously, Suwayomi-Server would store it's files under `${dataDir}/.local/share/Tachidesk`.

Migrating the data is done in two simple steps:
- Move the contents of `${dataDir}/.local/share/Tachidesk` into `${dataDir}`.
- Set `systemd.services.suwayomi-server.environment.JAVA_TOOL_OPTIONS` to
  `"-Dsuwayomi.tachidesk.config.server.rootDir=${config.services.suwayomi-server.dataDir}"`
  in your NixOS configuration.
