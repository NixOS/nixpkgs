# Modules Evalutation {#sec-modules-evaluation}

To evaluate a user's configuration on top of all of NixOS' `baseModules`,
the [`nixos/lib/default.nix`][nixos-lib-default] file exposes the public
`evalSystemConfiguration` function.

`evalSystemConfiguration` is implemented in [`nixos/lib/eval-config-system.nix`]
and it is the official entrypoint for evaluating a standard NixOS system configuration.

All user configuration or additional module implementations is passed as modules
to its `modules` parameter or is imported via `imports` inside these modules.

Things that should be made available for `imports` can't be, themselves, provisioned
via modules. Inside the module evaluation, resolving `imports` is a preprocessing
step that happens prior to the evaluation. That means at the time of `imports`
resolution, module system values are not yet available.

To solve this chicken-and-egg problem, a special parameter, `specialArgs` can
be passed to `evalSystemConfiguration` exclusively to pass items to modules
that should be made available for `imports`.

These `specialArgs` can be destructured in the same way as `config._module.args`.
However, unless the ability to `imports` is explicitly desired,
`config._module.args`, which can be defined in any regular module, should be
always preferred.

`evalSystemConfiguration` returns an attribute set that represents the final
system configuration. Thanks to the system configuration contained in `baseModules`,
the package that represents the final system's root filesystem can be found at
`config.system.build.toplevel`.

[nixos-lib-default]: https://github.com/NixOS/nixpkgs/tree/master/nixos/lib/default.nix
[nixos-lib-eval-config-system]: https://github.com/NixOS/nixpkgs/tree/master/nixos/lib/eval-config-system.nix
