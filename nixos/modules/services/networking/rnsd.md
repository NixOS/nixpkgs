# RNSD {#module-services-rnsd}

[Reticulum Network Stack](https://reticulum.network/) daemon (`rnsd`).

This module manages `rnsd` as a systemd service and stores runtime state under
`/var/lib/rnsd`.

## Quickstart {#module-services-rnsd-quickstart}

A minimal setup:

```nix
{
  services.rnsd.enable = true;
}
```

With custom settings and a persistent transport identity:

```nix
{
  services.rnsd = {
    enable = true;

    transportIdentityFile = "<path-to-rnsd-transport-identity-file>";

    settings = {
      reticulum = {
        enable_transport = true;
        share_instance = true;
        instance_name = "default";
        shared_instance_type = "unix";
      };
      interfaces = {
        auto = {
          type = "AutoInterface";
          enabled = true;
        };
      };
      openMulticastPorts = true;
    };
  };
}
```

At startup, settings provided through
[`services.rnsd.settings`](#opt-services.rnsd.settings) and
[`services.rnsd.transportIdentityFile`](#opt-services.rnsd.transportIdentityFile)
are copied into the service state directory with restrictive permissions.

## Hardware Access {#module-services-rnsd-hardware-access}

If `rnsd` must access serial devices (for example `/dev/ttyACM0`), add the
service user to additional groups:

```nix
{
  services.rnsd = {
    enable = true;
    extraGroups = [ "dialout" ];
  };
}
```

See [`services.rnsd.extraGroups`](#opt-services.rnsd.extraGroups) for details.

## Health Check {#module-services-rnsd-health-check}

You can optionally wait for `rnsd` to become responsive during startup using
`rnstatus`:

```nix
{
  services.rnsd = {
    enable = true;

    healthCheck = {
      enable = true;
      intervalSeconds = 2;
      timeoutSeconds = 120;
    };
  };
}
```

When enabled, startup fails if `rnstatus` does not succeed before
[`services.rnsd.healthCheck.timeoutSeconds`](#opt-services.rnsd.healthCheck.timeoutSeconds).
