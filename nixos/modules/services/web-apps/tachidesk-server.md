# Tachidesk-server {#module-services-tachidesk-server}

A free and open source manga reader server that runs extensions built for Tachiyomi.

## Basic usage {#module-services-tachidesk-server-basic-usage}

By default, the module will execute tachidesk-server backend and web UI:

```nix
{ ... }:

{
  services.tachidesk-server = {
    enable = true
  };
}
```

It runs in the systemd service named `tachidesk-server` in the data directory `/var/lib/tachidesk-server`.

You can change the default parameters with some other parameters:
```nix
{ ... }:

{
  services.tachidesk-server = {
    enable = true;

    dataDir = "/var/lib/tachidesk"; # Default is "/var/lib/tachidesk-server"
    openFirewall = true;

    config = {
      port = 4567;
    };
  };
}
```

If you want to create a desktop icon, you can activate the system tray option:

```nix
{ ... }:

{
  services.tachidesk-server = {
    enable = true;

    dataDir = "/var/lib/tachidesk"; # Default is "/var/lib/tachidesk-server"
    openFirewall = true;

    settings = {
      server.port = 4567;
      enableSystemTray = true;
    };
  };
}
```

## Basic authentication {#module-services-tachidesk-server-basic-auth}

You can configure a basic authentication to the web interface with:

```nix
{ ... }:

{
  services.tachidesk-server = {
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

## Extra configuration {#module-services-tachidesk-server-extra-config}

Not all the configuration options are available directly in this module, but you can add the other options of tachidesk-server with:

```nix
{ ... }:

{
  services.tachidesk-server = {
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
