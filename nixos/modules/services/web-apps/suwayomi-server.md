# Suwayomi-Server {#module-services-suwayomi-server}

A free and open source manga reader server that runs extensions built for Tachiyomi.

## Basic usage {#module-services-suwayomi-server-basic-usage}

By default, the module will execute Suwayomi-Server backend and web UI:

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
        basicAuthEnabled = true;
        basicAuthUsername = "username";

        # NOTE: this is not a real upstream option
        basicAuthPasswordFile = ./path/to/the/password/file;
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
        maxSourcesInParallel" = 6;
      };
    };
  };
}
```
