# LibreNMS {#module-services-librenms}

[LibreNMS](https://www.librenms.org/) is a fully featured network monitoring system that provides a wealth of features and device support.
The server setup can be automated using [services.librenms](#opt-services.librenms.enable).

## Initial setup {#module-services-librenms-initial-setup}

A basic configuration could look like this:

```nix
networking.firewall.allowedTCPPorts = [
  80 # Required for the web interface.
];
services.librenms = {
  enable = true;
  database = {
    createLocally = true;
    socket = "/run/mysqld/mysqld.sock";
  };
};
```

Create an admin user:

```bash
librenms-artisan user:add --role=admin admin
```

## Configuring LibreNMS

If you want to configure LibreNMS you can use the [services.librenms.settings](#opt-services.librenms.settings) option.
See https://docs.librenms.org/Support/Configuration/ for reference, all possible options are listed there.

## Ignore certain mount points

By default LibreNMS monitors every mount point including virtual devices.
This can be hard to get an overview over the actual state of the system.

To counter this you can configure LibreNMS to ignore specified mount points.
LibreNMS upstream ignores these mount points by default: https://github.com/librenms/librenms/blob/d231d628c537747e73a5decb1f6ee585ceffc647/resources/definitions/config_definitions.json#L4372
However these defaults aren't set on NixOS by default so we need to add them manually to the settings attribute set.

```nix
services.librenms = {
  settings = {
    ignore_mount = [
      # defaults: https://github.com/librenms/librenms/blob/2cb8d9f042c9658531d85047c62f958cb9519ac7/misc/config_definitions.json#L4189
      "/compat/linux/proc"
      "/compat/linux/sys"
      "/dev"
      "/kern"
      "/mnt/cdrom"
      "/proc"
      "/sys/fs/cgroup"
    ];
    ignore_mount_string = [
      # defaults: https://github.com/librenms/librenms/blob/2cb8d9f042c9658531d85047c62f958cb9519ac7/misc/config_definitions.json#L4238
      "packages"
      "devfs"
      "procfs"
      "linprocfs"
      "linsysfs"
      "UMA"
      "MALLOC"
    ];
  };
};
```

## Ingest Syslog traffic

It is a good security practice to ship logs to a remote system in case the system gets breaches so one can try to reconstruct the events even when the attacker deletes the logs on the compromised system.

LibreNMS has support for Syslog built in but it isn't configured by default on NixOS.

```nix
networking.firewall.allowedTCPPorts = [
  514 # Required for Syslog
];
networking.firewall.allowedUDPPorts = [
  514 # Required for Syslog
];
services.librenms.ingest-syslog.enable = true;
```
