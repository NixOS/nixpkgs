# udevCheckHook {#udevcheckhook}

The `udevCheckHook` derivation adds `udevCheckPhase` to the [`preInstallCheckHooks`](#ssec-installCheck-phase),
which finds all udev rules in all outputs and verifies them using `udevadm verify --resolve-names=never --no-style`.
It should be used in any package that has udev rules outputs to ensure the rules are and remain valid.

The hook runs in `installCheckPhase`, requiring `doInstallCheck` is enabled for the hook to take effect:
```nix
{
  lib,
  stdenv,
  udevCheckHook,
# ...
}:

stdenv.mkDerivation (finalAttrs: {
  # ...

  nativeInstallCheckInputs = [ udevCheckHook ];
  doInstallCheck = true;

  # ...
})
```
Note that for [`buildPythonPackage`](#buildpythonpackage-function) and [`buildPythonApplication`](#buildpythonapplication-function), `doInstallCheck` is enabled by default.

All outputs are scanned for their `/{etc,lib}/udev/rules.d` paths.
If no rule output is found, the hook is basically a no-op.

The `udevCheckHook` adds a dependency on `systemdMinimal`.
It is internally guarded behind `hostPlatform` supporting udev and `buildPlatform` being able to execute `udevadm`.
The hook does not need explicit platform checks in the places where it is used.

The hook can be disabled using `dontUdevCheck`, which is necessary if you want to run some different task in `installCheckPhase` on a package with broken udev rule outputs.
