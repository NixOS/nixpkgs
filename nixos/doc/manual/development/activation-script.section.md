# Activation script {#sec-activation-script}

The activation script is a bash script called to activate the new
configuration which resides in a NixOS system in `$out/activate`. Since its
contents depend on your system configuration, the contents may differ.
This chapter explains how the script works in general and some common NixOS
snippets. Please be aware that the script is executed on every boot and system
switch, so tasks that can be performed in other places should be performed
there (for example letting a directory of a service be created by systemd using
mechanisms like `StateDirectory`, `CacheDirectory`, ... or if that's not
possible using `preStart` of the service).

Activation scripts are defined as snippets using
[](#opt-system.activationScripts). They can either be a simple multiline string
or an attribute set that can depend on other snippets. The builder for the
activation script will take these dependencies into account and order the
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

This example creates an activation script snippet that is run after the `etc`
snippet. The special variable `supportsDryActivation` can be set so the snippet
is also run when `nixos-rebuild dry-activate` is run. To differentiate between
real and dry activation, the `$NIXOS_ACTION` environment variable can be
read which is set to `dry-activate` when a dry activation is done.

An activation script can write to special files instructing
`switch-to-configuration` to restart/reload units. The script will take these
requests into account and will incorperate the unit configuration as described
above. This means that the activation script will "fake" a modified unit file
and `switch-to-configuration` will act accordingly. By doing so, configuration
like [systemd.services.\<name\>.restartIfChanged](#opt-systemd.services) is
respected. Since the activation script is run **after** services are already
stopped, [systemd.services.\<name\>.stopIfChanged](#opt-systemd.services)
cannot be taken into account anymore and the unit is always restarted instead
of being stopped and started afterwards.

The files that can be written to are `/run/nixos/activation-restart-list` and
`/run/nixos/activation-reload-list` with their respective counterparts for
dry activation being `/run/nixos/dry-activation-restart-list` and
`/run/nixos/dry-activation-reload-list`. Those files can contain
newline-separated lists of unit names where duplicates are being ignored. These
files are not create automatically and activation scripts must take the
possiblility into account that they have to create them first.

## NixOS snippets {#sec-activation-script-nixos-snippets}

There are some snippets NixOS enables by default because disabling them would
most likely break your system. This section lists a few of them and what they
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
- `wrappers` creates setuid wrappers like `ping` and `sudo`
