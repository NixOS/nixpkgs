# `xfce4-dev-tools` {#xfce4-dev-tools}

This setup hook adds an `xdtAutogenPhase` that runs `xdt-autogen` before configure.

Use this hook for Xfce packages that need `xdt-autogen` before configure.
Add `xfce4-dev-tools` to `nativeBuildInputs` to enable the phase.

```nix
{
  nativeBuildInputs = [ xfce4-dev-tools ];
}
```

[]{#dontUseXdtAutogenPhase} Disable this behavior by setting `dontUseXdtAutogenPhase` to `true`.
