# Necessary system state {#ch-system-state}

Normally — on systems with a persistent `rootfs` — system services can persist state to
the filesystem without administrator intervention.

However, it is possible and not-uncommon to create [impermanent systems], whose
`rootfs` is either a `tmpfs` or reset during boot. While NixOS itself supports
this kind of configuration, special care needs to be taken.

[impermanent systems]: https://wiki.nixos.org/wiki/Impermanence


```{=include=} sections
nixos-state.section.md
systemd-state.section.md
zfs-state.section.md
```
