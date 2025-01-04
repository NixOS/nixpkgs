# Profiles {#ch-profiles}

In some cases, it may be desirable to take advantage of commonly-used,
predefined configurations provided by nixpkgs, but different from those
that come as default. This is a role fulfilled by NixOS's Profiles,
which come as files living in `<nixpkgs/nixos/modules/profiles>`. That
is to say, expected usage is to add them to the imports list of your
`/etc/configuration.nix` as such:

```nix
{
  imports = [
    <nixpkgs/nixos/modules/profiles/profile-name.nix>
  ];
}
```

Even if some of these profiles seem only useful in the context of
install media, many are actually intended to be used in real installs.

What follows is a brief explanation on the purpose and use-case for each
profile. Detailing each option configured by each one is out of scope.

```{=include=} sections
profiles/all-hardware.section.md
profiles/base.section.md
profiles/clone-config.section.md
profiles/demo.section.md
profiles/docker-container.section.md
profiles/graphical.section.md
profiles/hardened.section.md
profiles/headless.section.md
profiles/installation-device.section.md
profiles/perlless.section.md
profiles/minimal.section.md
profiles/qemu-guest.section.md
```
