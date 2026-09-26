# Tdarr {#module-services-tdarr}

*Source:* {file}`modules/services/misc/tdarr`

*Upstream documentation:* <https://docs.tdarr.io/\>

[Tdarr](https://tdarr.io) is a distributed transcoding system for automating media library transcoding operations using FFmpeg and HandBrake. It provides a web interface for managing transcoding nodes and configuring media processing pipelines.

## Basic Usage {#module-services-tdarr-basic-usage}

A minimal Tdarr setup with a server and one local node:

```nix
{
  services.tdarr = {
    enable = true;
    nodes.main = { };
  };
}
```

This creates a Tdarr server accessible at `http://localhost:8265` (web UI) with one processing node. The service runs as the `tdarr` user with data stored in `/var/lib/tdarr`.

::: {.note}
The `services.tdarr.enable` option is a convenience that enables both the server and all configured nodes. For finer control, use `services.tdarr.server.enable` and configure nodes independently.
:::

### Server Only {#module-services-tdarr-server-only}

To run only the Tdarr server without local nodes:

```nix
{
  services.tdarr.server.enable = true;
}
```

### Nodes Only {#module-services-tdarr-nodes-only}

To run node(s) connecting to a remote server:

```nix
{
  services.tdarr.nodes.worker1 = {
    serverURL = "http://192.168.1.100:8266";
    environmentFile = "/run/secrets/tdarr-node-env";
    # /run/secrets/tdarr-node-env contains:
    # apiKey=tapi_your_api_key_here
  };
}
```

## Authentication {#module-services-tdarr-authentication}

Authentication should be enabled for any installation accessible beyond localhost. Secrets are passed via environment files to avoid leaking them into the Nix store:

```nix
{
  services.tdarr = {
    enable = true;
    server = {
      auth.enable = true;
      environmentFile = "/run/secrets/tdarr-server-env";
      # /run/secrets/tdarr-server-env contains:
      # authSecretKey=your-secret-key
      # seededApiKey=tapi_your_api_key_here
    };
    nodes.main = {
      environmentFile = "/run/secrets/tdarr-node-env";
      # /run/secrets/tdarr-node-env contains:
      # apiKey=tapi_your_api_key_here
    };
  };
}
```

::: {.warning}
When using unmapped nodes, files in Tdarr's library source and cache folders become accessible through the network API. Authentication is strongly recommended in this configuration.
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
        workers = {
          transcodeCPU = 4;
          healthcheckCPU = 2;
        };
      };
      gpu-node = {
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

Workers determine how many parallel transcoding and healthcheck operations a node can perform:

```nix
{
  services.tdarr.nodes.main = {
    workers = {
      transcodeCPU = 4; # default: 2
      transcodeGPU = 1; # default: 0
      healthcheckCPU = 2; # default: 1
      healthcheckGPU = 0; # default: 0
    };
  };
}
```

::: {.note}
GPU workers require appropriate hardware and drivers. Worker counts can also be adjusted at runtime through the Tdarr web UI.
:::

### Node Types {#module-services-tdarr-nodes-types}

Tdarr supports two node types:

- **Mapped nodes** (default): Access files directly from the library paths configured in the Tdarr web interface.
- **Unmapped nodes**: Receive files over the network, useful for nodes without direct storage access.

```nix
{
  services.tdarr.nodes = {
    local.type = "mapped";
    remote = {
      type = "unmapped";
    };
  };
}
```

### Path Translators {#module-services-tdarr-nodes-path-translators}

Path translators enable cross-mount-point file access by mapping server paths to node paths:

```nix
{
  services.tdarr.nodes.remote-node = {
    pathTranslators = [
      {
        server = "/media/videos";
        node = "/mnt/nfs/videos";
      }
      {
        server = "/media/music";
        node = "/mnt/nfs/music";
      }
    ];
  };
}
```

## Networking {#module-services-tdarr-networking}

### Firewall Configuration {#module-services-tdarr-networking-firewall}

```nix
{
  services.tdarr.server = {
    enable = true;
    openFirewall = true; # Opens ports 8265 (web UI) and 8266 (server API)
  };
}
```

### Custom Ports {#module-services-tdarr-networking-ports}

```nix
{
  services.tdarr.server = {
    enable = true;
    serverPort = 9266; # default: 8266
    webUIPort = 9265; # default: 8265
  };
}
```

### IPv6 Support {#module-services-tdarr-networking-ipv6}

Enable dual-stack networking for IPv4 and IPv6 support:

```nix
{
  services.tdarr.server = {
    enable = true;
    serverDualStack = true;
  };
}
```

## Advanced Configuration {#module-services-tdarr-advanced}

### Plugin Updates {#module-services-tdarr-advanced-plugins}

Configure automatic plugin updates using cron expressions:

```nix
{
  services.tdarr.server = {
    enable = true;
    cronPluginUpdate = "0 2 * * *"; # Daily at 2 AM
  };
}
```

### Custom Data Directory {#module-services-tdarr-advanced-datadir}

```nix
{
  services.tdarr = {
    enable = true;
    dataDir = "/mnt/storage/tdarr";
  };
}
```

### Per-Node Data Directories {#module-services-tdarr-advanced-node-datadir}

```nix
{
  services.tdarr.nodes = {
    ssd-node.dataDir = "/mnt/ssd/tdarr-node";
    hdd-node.dataDir = "/mnt/hdd/tdarr-node";
  };
}
```

## Distributed Setup {#module-services-tdarr-distributed}

Tdarr's distributed architecture allows running nodes on separate machines from the server.

### Server Machine {#module-services-tdarr-distributed-server}

```nix
{
  services.tdarr.server = {
    enable = true;
    serverIP = "0.0.0.0";
    openFirewall = true;
    auth.enable = true;
    environmentFile = "/run/secrets/tdarr-server-env";
  };
}
```

### Worker Machines {#module-services-tdarr-distributed-nodes}

```nix
{
  services.tdarr.nodes.remote-worker = {
    serverURL = "http://192.168.1.100:8266";
    environmentFile = "/run/secrets/tdarr-node-env";
    workers = {
      transcodeCPU = 4;
      healthcheckCPU = 2;
    };
  };
}
```

::: {.note}
Ensure the server's firewall allows incoming connections on the configured ports. Both server and nodes must have access to the same media and transcode cache paths (for mapped nodes).
:::
