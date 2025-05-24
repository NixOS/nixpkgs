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
Be aware, that in case you want to extend a setting that is of type list, you will overwrite the defaults and not extend them.
Therefore you have to include the defaults as well, if you want to use them.

## Ignore certain mount points

By default LibreNMS monitors every mount point including virtual devices.
This can be hard to get an overview over the actual state of the system.

To counter this you can configure LibreNMS to ignore specified mount points.
LibreNMS upstream ignores these mount points by default: [Default Ignored mount points](https://github.com/librenms/librenms/blob/88fe1a7abdb500d9a2d4c45f9872df54c9ff8062/misc/config_definitions.json#L4348)
When we want to extend that list we need to include the defaults as well, otherwise they get overwritten by our new list.

```nix
services.librenms = {
  settings = {
    ignore_mount = [
      "/example/mount/point"
      # defaults: https://github.com/librenms/librenms/blob/88fe1a7abdb500d9a2d4c45f9872df54c9ff8062/misc/config_definitions.json#L4349
      "/compat/linux/proc"
      "/compat/linux/sys"
      "/dev"
      "/kern"
      "/mnt/cdrom"
      "/proc"
      "/sys/fs/cgroup"
    ];
    ignore_mount_string = [
      "example_string"
      # defaults: https://github.com/librenms/librenms/blob/88fe1a7abdb500d9a2d4c45f9872df54c9ff8062/misc/config_definitions.json#L4398
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
