# Non Switchable Systems {#sec-non-switchable-system}

In certain systems, most notably image based appliances, updates are handled
outside the system. This means that you do not need to rebuild your
configuration on the system itself anymore.

If you want to build such a system, you can use the `image-based-appliance`
profile:

```nix
{ modulesPath, ... }:
{
  imports = [ "${modulesPath}/profiles/image-based-appliance.nix" ];
}
```

The most notable deviation of this profile from a standard NixOS configuration
is that after building it, you cannot switch *to* the configuration anymore.
The profile sets `config.system.switch.enable = false;`, which excludes
`switch-to-configuration`, the central script called by `nixos-rebuild`, from
your system. Removing this script makes the image lighter and slightly more
secure.
