# Activation script {#sec-activation-script}

The activation script is a bash script that can be found in `$out/activate` on a
NixOS system and that is called to activate the new configuration. Since its
content depends on the configuration of the system, the contents may vary.
This chapter explains how the script works in general and some common NixOS
snippets. Please note that the script will be executed on every boot and system
switch, so tasks that can be done in other places should be done
there (e.g. have a directory of a service be created by systemd using
mechanisms like `StateDirectory`, `CacheDirectory`, ... or if that's not
possible, use `preStart` of the service).

Activation scripts are defined as snippets using
[](#opt-system.activationScripts). They can be either a simple multi-line string,
or an attribute set that can depend on other snippets. The activation script
builder will take these dependencies into account and arranges the
snippets accordingly. As a simple example:

```nix
system.activationScripts.my-activation-script = {
  deps = [ "etc" ];
  # supportsDryActivation = true;
  text = ''
    echo "Hallo i bims"
  '';
};
```

This example creates an activation script snippet to run after the `etc`
snippet. The special variable `supportsDryActivation` can be set so that the
snippet is also run when `nixos-rebuild dry-activate` is run. To distinguish between
real and dry activation, the `$NIXOS_ACTION` environment variable can be
read which is set to `dry-activate` when a dry activation is performed.

An activation script can write to special files instructing
`switch-to-configuration` to restart/reload units. The script will take these
requests into account and will incorporate the unit configuration as described
above. This means that the activation script will "fake" a modified unit file
and `switch-to-configuration` will act accordingly. This will respect configurations
such as [systemd.services.\<name\>.restartIfChanged](#opt-systemd.services).
As the activation script is run **after** services have already been
stopped, [systemd.services.\<name\>.stopIfChanged](#opt-systemd.services)
can no longer be taken into account, and the unit will always be restarted, rather
than stopped and then started again.

The files that can be written to are `/run/nixos/activation-restart-list` and
`/run/nixos/activation-reload-list` with their respective counterparts for
dry activation being `/run/nixos/dry-activation-restart-list` and
`/run/nixos/dry-activation-reload-list`. Those files can contain
newline-separated lists of unit names with duplicates being ignored. These
files are not created automatically, so activation scripts must be aware
that they may need to be created first.

## NixOS snippets {#sec-activation-script-nixos-snippets}

There are some snippets that NixOS enables by default because disabling them would
most likely break your system. This section lists some of them and what they
do:

- `binsh` creates `/bin/sh` which points to the runtime shell
- `etc` sets up the contents of `/etc`, this includes systemd units and
  excludes `/etc/passwd`, `/etc/group`, and `/etc/shadow` (which are managed by
  the `users` snippet)
- `hostname` sets the system's hostname in the kernel (not in `/etc`)
- `modprobe` sets the path to the `modprobe` binary for module auto-loading
- `nix` prepares the nix store and adds a default initial channel
- `specialfs` is responsible for mounting filesystems like `/proc` and `sys`
- `users` creates and removes users and groups by managing `/etc/passwd`,
  `/etc/group` and `/etc/shadow`. This also creates home directories
- `usrbinenv` creates `/usr/bin/env`
- `var` creates some directories in `/var` that are not service-specific
- `wrappers` creates setuid wrappers like `sudo`
