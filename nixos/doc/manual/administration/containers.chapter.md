# Container Management {#ch-containers}

NixOS allows you to easily run other NixOS instances as *containers*.
Containers are a light-weight approach to virtualisation that runs
software in the container at the same speed as in the host system. NixOS
containers share the Nix store of the host, making container creation
very efficient.

::: {.warning}
Currently, NixOS containers are not perfectly isolated from the host
system. This means that a user with root access to the container can do
things that affect the host. So you should not give container root
access to untrusted users.
:::

NixOS containers can be created in two ways: imperatively, using the
command `nixos-container`, and declaratively, by specifying them in your
`configuration.nix`. The declarative approach implies that containers
get upgraded along with your host system when you run `nixos-rebuild`,
which is often not what you want. By contrast, in the imperative
approach, containers are configured and updated independently from the
host system.

```{=include=} sections
imperative-containers.section.md
declarative-containers.section.md
container-networking.section.md
```
