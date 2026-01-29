# Tdarr {#module-services-tdarr}

*Source:* {file`modules/services/video/tdarr.nix`}

*Upstream documentation:* <https://docs.tdarr.io/>

[Tdarr](https://tdarr.io) is a distributed transcoding system for automating media library transcoding operations using FFmpeg and HandBrake. It provides a web interface for managing transcoding nodes and configuring media processing pipelines.

## Basic Usage {#module-services-tdarr-basic-usage}

A minimal Tdarr setup with a server and one local node can be configured as follows:

```nix
{
  services.tdarr = {
    enable = true;
    nodes.main = {
      enable = true;
    };
  };
}
```

This creates a Tdarr server accessible at `http://localhost:8265` (web UI) with one processing node. The service runs as the `tdarr` user with data stored in `/var/lib/tdarr`.

## Authentication {#module-services-tdarr-authentication}

Authentication should be enabled for any installation accessible beyond localhost, especially when using unmapped nodes:

```nix
{
  services.tdarr = {
    enable = true;
    auth = {
      enable = true;
      secretKey = "your-secret-key-here";
      apiKey = "your-api-key-here";
    };
    nodes.main.enable = true;
  };
}
```

::: {.warning}
When [allowUnmappedNodes](#opt-services.tdarr.allowUnmappedNodes) is enabled, files in Tdarr's library source and cache folders become accessible through the network API. Authentication is strongly recommended in this configuration.
:::

## Node Configuration {#module-services-tdarr-nodes}

### Multiple Nodes {#module-services-tdarr-nodes-multiple}

You can run multiple nodes on the same machine with different configurations:

```nix
{
  services.tdarr = {
    enable = true;
    nodes = {
      cpu-node = {
        enable = true;
        workers = {
          transcodeCPU = 4;
          healthcheckCPU = 2;
        };
      };
      gpu-node = {
        enable = true;
        workers = {
          transcodeGPU = 2;
          transcodeCPU = 1;
          healthcheckGPU = 1;
        };
      };
    };
  };
}
```

### Worker Configuration {#module-services-tdarr-nodes-workers}

Workers determine how many parallel transcoding and healthcheck operations a node can perform. The default configuration provides 2 CPU transcode workers and 1 CPU healthcheck worker. Adjust these based on your hardware:

```nix
{
  services.tdarr.nodes.main = {
    enable = true;
    workers = {
      transcodeCPU = 4; # Number of CPU transcode workers
      transcodeGPU = 1; # Number of GPU transcode workers
      healthcheckCPU = 2; # Number of CPU healthcheck workers
      healthcheckGPU = 0; # Number of GPU healthcheck workers
    };
  };
}
```

::: {.note}
GPU workers require appropriate hardware and drivers. Ensure your system has GPU acceleration properly configured before enabling GPU workers.
:::

### Node Types {#module-services-tdarr-nodes-types}

Tdarr supports two node types:

- **Mapped nodes** (default): Access files directly from the library paths configured in the Tdarr web interface
- **Unmapped nodes**: Receive files over the network, useful for nodes without direct storage access

```nix
{
  services.tdarr.nodes = {
    local = {
      type = "mapped"; # Direct file access
    };
    remote = {
      type = "unmapped";
      unmappedCache = "/var/cache/tdarr-remote";
    };
  };
}
```

### Path Translators {#module-services-tdarr-nodes-path-translators}

Path translators enable cross-platform file access by mapping server paths to node paths. This is essential when the server and nodes run on different operating systems or mount points:

```nix
{
  services.tdarr.nodes.windows-node = {
    enable = true;
    pathTranslators = [
      {
        server = "/media/videos";
        node = "W:/videos";
      }
      {
        server = "/media/music";
        node = "W:/music";
      }
    ];
  };
}
```

## Networking {#module-services-tdarr-networking}

### Firewall Configuration {#module-services-tdarr-networking-firewall}

To allow external access to Tdarr, enable the firewall option:

```nix
{
  services.tdarr = {
    enable = true;
    openFirewall = true; # Opens ports 8265 (web UI) and 8266 (server API)
  };
}
```

Alternatively, manually configure the firewall:

```nix
{
  networking.firewall.allowedTCPPorts = [
    8265
    8266
  ];
}
```

### Custom Ports {#module-services-tdarr-networking-ports}

The default ports can be changed:

```nix
{
  services.tdarr = {
    enable = true;
    serverPort = 9266; # Server API port (default: 8266)
    webUIPort = 9265; # Web UI port (default: 8265)
  };
}
```

### IPv6 Support {#module-services-tdarr-networking-ipv6}

Enable dual-stack networking for IPv4 and IPv6 support:

```nix
{
  services.tdarr = {
    enable = true;
    serverDualStack = true;
  };
}
```

This is particularly useful in Kubernetes environments and modern networking setups requiring IPv6 support.

## Advanced Configuration {#module-services-tdarr-advanced}

### Plugin Updates {#module-services-tdarr-advanced-plugins}

Configure automatic plugin updates using cron expressions:

```nix
{
  services.tdarr = {
    enable = true;
    cronPluginUpdate = "0 2 * * *"; # Daily at 2 AM
  };
}
```

### Custom Data Directory {#module-services-tdarr-advanced-datadir}

Change the data directory location:

```nix
{
  services.tdarr = {
    enable = true;
    dataDir = "/mnt/storage/tdarr";
  };
}
```

### Per-Node Data Directories {#module-services-tdarr-advanced-node-datadir}

Each node can have its own data directory:

```nix
{
  services.tdarr.nodes = {
    ssd-node = {
      enable = true;
      dataDir = "/mnt/ssd/tdarr-node";
    };
    hdd-node = {
      enable = true;
      dataDir = "/mnt/hdd/tdarr-node";
    };
  };
}
```

### Extra Configuration {#module-services-tdarr-advanced-extra}

For configuration options not directly exposed by the module, use [extraServerConfig](#opt-services.tdarr.extraServerConfig) and [extraNodeConfig](#opt-services.tdarr.extraNodeConfig):

```nix
{
  services.tdarr = {
    enable = true;
    extraServerConfig = {
      customOption = "value";
    };
    nodes.main = {
      enable = true;
      extraNodeConfig = {
        customNodeOption = "value";
      };
    };
  };
}
```

## Distributed Setup {#module-services-tdarr-distributed}

Tdarr's distributed architecture allows running nodes on separate machines from the server. On the server machine:

```nix
{
  services.tdarr = {
    enable = true;
    serverIP = "0.0.0.0"; # Listen on all interfaces
    openFirewall = true;
    auth = {
      enable = true;
      secretKey = "shared-secret";
      apiKey = "tapi_your_api_key_here";
    };
  };
}
```

On worker machines, configure nodes to connect to the remote server. Note that remote nodes should be configured using environment variables or the Tdarr web interface rather than this NixOS module, as the module is designed for running server and nodes on the same machine.

For remote nodes, you can run Tdarr Node manually:

```nix
{
  # Install Tdarr package but don't use the service module
  environment.systemPackages = [ pkgs.tdarr ];

  # Create a systemd service manually if desired
  systemd.services.tdarr-remote-node = {
    description = "Tdarr Remote Node";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      serverURL = "http://192.168.1.100:8266";
      nodeName = "remote-worker-1";
      apiKey = "tapi_your_api_key_here";
    };

    serviceConfig = {
      ExecStart = "${pkgs.tdarr}/bin/tdarr-node";
      Restart = "on-failure";
      User = "tdarr";
      Group = "tdarr";
    };
  };
}
```
