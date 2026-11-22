# julec.hook {#julec-hook}

[Jule](https://jule.dev) is an effective programming language designed to build efficient, fast, reliable and safe software while maintaining simplicity.

In Nixpkgs, `jule.hook` overrides the default build, check and install phases.

## Example code snippet {#julec-hook-example-code-snippet}

```nix
{
  julec,
  clangStdenv,
}:

clangStdenv.mkDerivation (finalAttrs: {
  # ...

  nativeBuildInputs = [ julec.hook ];

  # Customize filenames if needed
  JULE_SRC_DIR = "./src";
  JULE_OUT_DIR = "./bin";
  JULE_OUT_NAME = "hello-jule";
  JULE_TEST_DIR = "./tests";
  JULE_TEST_OUT_DIR = "./test-bin";
  JULE_TEST_OUT_NAME = "hello-jule-test";

  # ...
})
```

## Variables controlling julec.hook {#julec-hook-variables}

### `JULE_SRC_DIR` {#julec-hook-variable-jule-src-dir}

Specifies the source directory containing `main.jule`.
Default is `./src`.

### `JULE_OUT_DIR` {#julec-hook-variable-jule-out-dir}

Specifies the output directory for the compiled binary.
Default is `./bin`.

### `JULE_OUT_NAME` {#julec-hook-variable-jule-out-name}

Specifies the name of the compiled binary.
Default is `output`.

### `JULE_TEST_DIR` {#julec-hook-variable-jule-test-dir}

Specifies the directory containing test files.
Default is the value of [`JULE_SRC_DIR`](#julec-hook-variable-jule-src-dir).

### `JULE_TEST_OUT_DIR` {#julec-hook-variable-jule-test-out-dir}

Specifies the output directory for compiled test binaries.
Default is the value of [`JULE_OUT_DIR`](#julec-hook-variable-jule-out-dir).

### `JULE_TEST_OUT_NAME` {#julec-hook-variable-jule-test-out-name}

Specifies the name of the compiled test binary.
Default is the value of [`JULE_OUT_NAME`](#julec-hook-variable-jule-out-name) with `-test` suffix.

### `dontUseJulecBuild` {#julec-hook-variable-dontusejulecbuild}

When set to true, doesn't use the predefined `julecBuildHook`.
Default is false.

### `dontUseJulecCheck` {#julec-hook-variable-dontusejuleccheck}

When set to true, doesn't use the predefined `julecCheckHook`.
Default is false.

### `dontUseJulecInstall` {#julec-hook-variable-dontusejulecinstall}

When set to true, doesn't use the predefined `julecInstallHook`.
Default is false.
