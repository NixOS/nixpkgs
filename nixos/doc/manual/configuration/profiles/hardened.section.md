# Hardened {#sec-profile-hardened}

A profile with most (vanilla) hardening options enabled by default,
potentially at the cost of stability, features and performance.

This includes a hardened kernel, and limiting the system information
available to processes through the `/sys` and
`/proc` filesystems. It also disables the User Namespaces
feature of the kernel, which stops Nix from being able to build anything
(this particular setting can be overridden via
[](#opt-security.allowUserNamespaces)). See the
[profile source](https://github.com/nixos/nixpkgs/tree/master/nixos/modules/profiles/hardened.nix)
for further detail on which settings are altered.

::: {.warning}
This profile enables options that are known to affect system
stability. If you experience any stability issues when using the
profile, try disabling it. If you report an issue and use this
profile, always mention that you do.
:::
