# Modularity {#sec-modularity}

The NixOS configuration mechanism is modular. If your
`configuration.nix` becomes too big, you can split it into multiple
files. Likewise, if you have multiple NixOS configurations (e.g. for
different computers) with some commonality, you can move the common
configuration into a shared file.

Modules have exactly the same syntax as `configuration.nix`. In fact,
`configuration.nix` is itself a module. You can use other modules by
including them from `configuration.nix`, e.g.:

```nix
{ config, pkgs, ... }:

{ imports = [ ./vpn.nix ./kde.nix ];
  services.httpd.enable = true;
  environment.systemPackages = [ pkgs.emacs ];
  # ...
}
```

Here, we include two modules from the same directory, `vpn.nix` and
`kde.nix`. The latter might look like this:

```nix
{ config, pkgs, ... }:

{ services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  environment.systemPackages = [ pkgs.vim ];
}
```

Note that both `configuration.nix` and `kde.nix` define the option
[](#opt-environment.systemPackages). When multiple modules define an
option, NixOS will try to *merge* the definitions. In the case of
[](#opt-environment.systemPackages) the lists of packages will be
concatenated. The value in `configuration.nix` is
merged last, so for list-type options, it will appear at the end of the
merged list. If you want it to appear first, you can use `mkBefore`:

```nix
{
  boot.kernelModules = mkBefore [ "kvm-intel" ];
}
```

This causes the `kvm-intel` kernel module to be loaded before any other
kernel modules.

For other types of options, a merge may not be possible. For instance,
if two modules define [](#opt-services.httpd.adminAddr),
`nixos-rebuild` will give an error:

```plain
The unique option `services.httpd.adminAddr' is defined multiple times, in `/etc/nixos/httpd.nix' and `/etc/nixos/configuration.nix'.
```

When that happens, it's possible to force one definition take precedence
over the others:

```nix
{
  services.httpd.adminAddr = pkgs.lib.mkForce "bob@example.org";
}
```

When using multiple modules, you may need to access configuration values
defined in other modules. This is what the `config` function argument is
for: it contains the complete, merged system configuration. That is,
`config` is the result of combining the configurations returned by every
module. (If you're wondering how it's possible that the (indirect) *result*
of a function is passed as an *input* to that same function: that's
because Nix is a "lazy" language --- it only computes values when
they are needed. This works as long as no individual configuration
value depends on itself.)

For example, here is a module that adds some packages to
[](#opt-environment.systemPackages) only if
[](#opt-services.xserver.enable) is set to `true` somewhere else:

```nix
{ config, pkgs, ... }:

{ environment.systemPackages =
    if config.services.xserver.enable then
      [ pkgs.firefox
        pkgs.thunderbird
      ]
    else
      [ ];
}
```

With multiple modules, it may not be obvious what the final value of a
configuration option is. The command `nixos-option` allows you to find
out:

```ShellSession
$ nixos-option services.xserver.enable
true

$ nixos-option boot.kernelModules
[ "tun" "ipv6" "loop" ... ]
```

Interactive exploration of the configuration is possible using `nix
  repl`, a read-eval-print loop for Nix expressions. A typical use:

```ShellSession
$ nix repl '<nixpkgs/nixos>'

nix-repl> config.networking.hostName
"mandark"

nix-repl> map (x: x.hostName) config.services.httpd.virtualHosts
[ "example.org" "example.gov" ]
```

While abstracting your configuration, you may find it useful to generate
modules using code, instead of writing files. The example below would
have the same effect as importing a file which sets those options.

```nix
{ config, pkgs, ... }:

let netConfig = hostName: {
  networking.hostName = hostName;
  networking.useDHCP = false;
};

in

{ imports = [ (netConfig "nixos.localdomain") ]; }
```
