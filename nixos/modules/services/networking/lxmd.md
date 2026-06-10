# LXMD {#module-services-lxmd}

[LXMF](https://github.com/markqvist/lxmf) daemon (`lxmd`).

This module runs `lxmd` as a systemd service with `DynamicUser = true` and
`StateDirectory = "lxmd"` directives.

## Quickstart {#module-services-lxmd-quickstart}

A minimal setup:

```nix
{
  services.lxmd.enable = true;
}
```

With custom LXMD and RNSD settings:

```nix
{
  services.lxmd = {
    enable = true;

    identityFile = "<path-to-lxmd-identity-file>";

    settings = {
      propagation-node = {
        autopeer = true;
      };
    };

    rnsd = {
      transportIdentityFile = "<path-to-rnsd-transport-identity-file>";

      settings = {
        reticulum = {
          require_shared_instance = true;
          is_shared_instance = true;
          enable_transport = true;
          instance_name = "default";
          shared_instance_type = "unix";
        };
      };
    };
  };
}
```

At startup, settings provided through
[`services.lxmd.settings`](#opt-services.lxmd.settings),
[`services.lxmd.identityFile`](#opt-services.lxmd.identityFile), and
[`services.lxmd.rnsd.settings`](#opt-services.lxmd.rnsd.settings) are copied
into the service state directory.

## Health Check {#module-services-lxmd-health-check}

You can optionally wait for `lxmd` to become responsive during startup using
`lxmd --status`:

```nix
{
  services.lxmd = {
    enable = true;

    healthCheck = {
      enable = true;
      intervalSeconds = 2;
      timeoutSeconds = 120;
    };
  };
}
```

When enabled, startup fails if `lxmd --status` does not succeed before
[`services.lxmd.healthCheck.timeoutSeconds`](#opt-services.lxmd.healthCheck.timeoutSeconds).

## Communicating With RNSD {#module-services-lxmd-communication-with-rnsd}

Even though both services are hardened (via Systemd's `DynamicUser = true` and
`StateDirectory = "lxmd"` directives), `lxmd` can still communicate with `rnsd`
in several ways.

### Option 1: Shared Instance Over Unix RPC {#module-services-lxmd-communication-rpc}

Use a shared Reticulum instance exposed through a local Unix RPC socket:

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
    };
  };

  services.lxmd = {
    enable = true;

    identityFile = "<path-to-lxmd-identity-file>";

    settings = {
      # LXMD settings, run `lxmd --exampleconfig` for details
    };

    rnsd = {
      transportIdentityFile = "<path-to-rnsd-transport-identity-file>";

      settings = {
        reticulum = {
          require_shared_instance = true;
          is_shared_instance = true;
          enable_transport = true;
          instance_name = "default";
          shared_instance_type = "unix";
        };
      };
    };
  };
}
```

In this model, `lxmd` points to an RNS configuration that joins the shared
instance. Both RNS transport identity files in `rnsd` and `lxmd` must be the
same. If you use different transport identity files, then set the same `rpc_key`
in both `rnsd` configurations to allow them to communicate securely.

It is also possible to use a shared instance over TCP, please refer to the
[Reticulum documentation](https://reticulum.network/manual/) for details.

### Option 2: Isolated Instances Connected Through BackboneInterface {#module-services-lxmd-communication-backbone}

Reticulum applications (`rnsd`, `lxmd`, and others) can be isolated by running:

- one primary `rnsd` service instance as a non-privileged service account,
- one instance per application, each with its own user and configuration,
- a `BackboneInterface` between each isolated application instance and the
  primary instance.

On the primary `rnsd` instance, the `BackboneInterface` is configured to accept
connections from the isolated instances, as such:

```nix
{
  services.rnsd = {
    enable = true;

    transportIdentityFile = "<path-to-rnsd-transport-identity-file>";

    settings = {
      reticulum = {
        # RNSD settings, run `rnsd --exampleconfig` for details
      };
      interfaces = {
        root = {
          type = "BackboneInterface";
          enabled = true;
          mode = "gateway";
          discoverable = true;
          listen_ip = "127.0.0.1";
          listen_port = 4242;
        };
      };
    };
  };
}
```

Then, on each isolated application instance, the `BackboneInterface` is
configured to connect to the primary instance:

```nix
{
  services.lxmd = {
    enable = true;

    identityFile = "<path-to-lxmd-identity-file>";

    settings = {
      # LXMD settings, run `lxmd --exampleconfig` for details
    };

    rnsd = {
      transportIdentityFile = "<path-to-rnsd-transport-identity-file>";

      settings = {
        reticulum = {
          # RNSD settings, run `rnsd --exampleconfig` for details
        };
        interfaces = {
          local = {
            type = "BackboneInterface";
            enabled = true;
            target_host = "127.0.0.1";
            target_port = 4242;
          };
        };
      };
    };
  };
}
```

The primary `rnsd` instance serves system-local `BackboneInterface` links for
applications and external interfaces for the wider network. Each isolated app
uses its own RNS configuration directory (for example with
`--rnsconfig <path>`), and that local instance connects to the root instance
through `BackboneInterface`.

Running multiple instances increases memory usage and adds one extra hop, but
the performance impact is generally negligible.
