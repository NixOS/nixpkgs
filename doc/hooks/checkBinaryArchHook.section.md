# checkBinaryArchHook {#checkbinaryarchhook}

This hook verifies that ELF binaries in a package match the expected host platform architecture.
It helps catch cases where prebuilt binaries for the wrong architecture are accidentally included,
which is particularly useful for cross-compilation scenarios or packages that fetch prebuilt binaries.

The hook runs during `fixupPhase` and fails the build if any ELF binary has a different `e_machine`
value than expected for the host platform.

## Usage {#checkbinaryarchhook-usage}

```nix
{
  lib,
  stdenv,
  checkBinaryArchHook,
}:

stdenv.mkDerivation {
  # ...

  nativeBuildInputs = [ checkBinaryArchHook ];

  # ...
}
```

## How it works {#checkbinaryarchhook-how-it-works}

The hook:

1. Compiles an empty C file using the host compiler (`$CC`) to get a reference object file
2. Extracts the `e_machine` value from the ELF header of this reference object
3. Scans all ELF files in `bin/` and `lib/` directories (recursively) across all outputs
4. Compares each ELF file's `e_machine` value against the expected value
5. Fails the build if any mismatch is found, reporting the mismatched files

## Configuration variables {#checkbinaryarchhook-configuration}

### `dontCheckBinaryArch` {#checkbinaryarchhook-dontCheckBinaryArch}

Set to `true` to disable the check entirely.

```nix
{
  dontCheckBinaryArch = true;
}
```

### `checkBinaryArchExtraPaths` {#checkbinaryarchhook-checkBinaryArchExtraPaths}

Additional paths to check beyond the default `bin/` and `lib/` directories.
Paths are checked recursively.

```nix
{
  checkBinaryArchExtraPaths = [
    "$out/libexec"
    "$out/share/foo/bin"
  ];
}
```

### `checkBinaryArchDebug` {#checkbinaryarchhook-checkBinaryArchDebug}

Set to `true` to enable verbose debug output, which shows each file being checked
and the architecture detection process.

```nix
{
  checkBinaryArchDebug = true;
}
```

## Common causes of failures {#checkbinaryarchhook-common-causes}

When the hook fails, it typically indicates one of:

- **Prebuilt binary fetched for wrong architecture**: The package downloads binaries that don't match the target platform
- **Cross-compilation misconfiguration**: Build system is using the wrong compiler or targeting the wrong architecture

## Example error output {#checkbinaryarchhook-example-error}

```
check-binary-arch: ERROR: Binary architecture mismatch detected!

Expected architecture: aarch64 (e_machine=183)

Mismatched binaries:
  /nix/store/.../bin/wrongarch
    Found:    x86_64 (e_machine=62)
    Expected: aarch64 (e_machine=183)

This usually means the binary was built for a different platform.
Common causes:
  - Prebuilt binary fetched for wrong architecture
  - Cross-compilation misconfiguration

To disable this check, set: dontCheckBinaryArch = true;
```
