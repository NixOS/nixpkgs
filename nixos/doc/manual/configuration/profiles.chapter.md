# Profiles {#ch-profiles}

In some cases, it may be desirable to take advantage of commonly-used,
predefined configurations provided by nixpkgs, but different from those
that come as default. This is a role fulfilled by NixOS's Profiles,
which come as files living in `<nixpkgs/nixos/modules/profiles>`. That
is to say, expected usage is to add them to the imports list of your
`/etc/configuration.nix` as such:

```nix
imports = [
  <nixpkgs/nixos/modules/profiles/profile-name.nix>
];
```

Even if some of these profiles seem only useful in the context of
install media, many are actually intended to be used in real installs.

What follows is a brief explanation on the purpose and use-case for each
profile. Detailing each option configured by each one is out of scope.

```{=docbook}
<xi:include href="profiles/all-hardware.section.xml" />
<xi:include href="profiles/base.section.xml" />
<xi:include href="profiles/clone-config.section.xml" />
<xi:include href="profiles/demo.section.xml" />
<xi:include href="profiles/docker-container.section.xml" />
<xi:include href="profiles/graphical.section.xml" />
<xi:include href="profiles/hardened.section.xml" />
<xi:include href="profiles/headless.section.xml" />
<xi:include href="profiles/installation-device.section.xml" />
<xi:include href="profiles/minimal.section.xml" />
<xi:include href="profiles/qemu-guest.section.xml" />
```
