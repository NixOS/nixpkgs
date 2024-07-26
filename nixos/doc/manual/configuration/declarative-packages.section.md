# Declarative Package Management {#sec-declarative-package-mgmt}

With declarative package management, you specify which packages you want
on your system by setting the option
[](#opt-environment.systemPackages). For instance, adding the
following line to `configuration.nix` enables the Mozilla Thunderbird
email application:

```nix
environment.systemPackages = [ pkgs.thunderbird ];
```

The effect of this specification is that the Thunderbird package from
Nixpkgs will be built or downloaded as part of the system when you run
`nixos-rebuild switch`.

::: {.note}
Some packages require additional global configuration such as D-Bus or
systemd service registration so adding them to
[](#opt-environment.systemPackages) might not be sufficient. You are
advised to check the [list of options](#ch-options) whether a NixOS
module for the package does not exist.
:::

You can get a list of the available packages as follows:

```ShellSession
$ nix-env -qaP '*' --description
nixos.firefox   firefox-23.0   Mozilla Firefox - the browser, reloaded
...
```

The first column in the output is the *attribute name*, such as
`nixos.thunderbird`.

Note: the `nixos` prefix tells us that we want to get the package from
the `nixos` channel and works only in CLI tools. In declarative
configuration use `pkgs` prefix (variable).

To "uninstall" a package, remove it from
[](#opt-environment.systemPackages) and run `nixos-rebuild switch`.

```{=include=} sections
customizing-packages.section.md
adding-custom-packages.section.md
```
