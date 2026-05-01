# systemd-verify-units-hook {#systemd-verify-units-hook}

The `systemd-verify-units-hook` derivation adds `systemdVerifyUnitsPhase` to the [`preInstallCheckHooks`](#ssec-installCheck-phase),
which finds all systemd units in all outputs and verifies them using `systemd-analyze verify --man=no --recursive-errors=no`.
It should be used in any package that vendors its own systemd units, to ensure that all keys and sections are valid.

The hook runs in `installCheckPhase`, requiring `doInstallCheck` is enabled for the hook to take effect:

```nix
{
  lib,
  stdenv,
  systemd-verify-units-hook,
  # ...
}:

stdenv.mkDerivation (finalAttrs: {
  # ...

  nativeInstallCheckInputs = [ systemd-verify-units-hook ];
  doInstallCheck = true;

  # ...
})
```

Note that for [`buildPythonPackage`](#buildpythonpackage-function) and [`buildPythonApplication`](#buildpythonapplication-function), `doInstallCheck` is enabled by default.

All outputs are scanned for their `/{etc,lib}/share/systemd/system` paths by default, as well as any extra paths listed.
If no unit files are found, the hook is basically a no-op.

The `systemd-verify-units-hook` adds a dependency on `systemd`.
It is internally guarded behind `hostPlatform` supporting systemd and `buildPlatform` being able to execute `systemd`.
The hook does not need explicit platform checks in the places where it is used.

By default, the hook is configured to allow a set of known non-standard keys in systemd unit files, that is commonly used in NixOS.

## Variables controlling systemd-verify-units-hook {#systemd-verify-units-hook-variables-controlling}

### systemd-verify-units-hook Exclusive Variables {#systemd-verify-units-hook-exclusive-variables}

#### `dontSystemdVerifyUnits` {#dont-systemd-verify-units}

The hook can be disabled by setting this variable to `true`.

#### `systemdVerifySkipDefaultPaths` {#systemd-verify-skip-default-paths}

Whether to skip verifying units in the default systemd unit paths:

- `/etc/share/systemd/system`
- `/lib/share/systemd/system`

#### `systemdVerifyExtraUnits` {#systemd-verify-extra-units}

A list of additional paths to systemd unit files to verify.

These paths can include glob patterns.

#### `systemdVerifySkipUnits` {#systemd-verify-skip-units}

A list of paths to systemd unit files to skip verifying.

These paths can either be the relative path within the package output to the unit file,
or the base name of the unit file.

#### `systemdVerifyAllowUnknownKeys` {#systemd-verify-allow-unknown-keys}

A list of extra keys in the systemd unit files to allow, despite systemd not recognizing them by default.

#### `systemdVerifyAllowUnknownSections` {#systemd-verify-allow-unknown-sections}

A list of extra sections in the systemd unit files to allow, despite systemd not recognizing them by default.


#### `systemdVerifyDisableDefaultUnknownKeys` {#systemd-verify-disable-default-unknown-keys}

Whether to disable the default set of allowed unknown keys in systemd unit files.
