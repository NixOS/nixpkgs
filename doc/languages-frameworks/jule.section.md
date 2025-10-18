# Jule {#sec-language-jule}

## Building Jule modules with `buildJuleModule` {#ssec-language-jule}

The function `buildJuleModule` builds Jule programs organized with [modules](https://manual.jule.dev/packages/modules/).

### Example for `buildJuleModule` {#ex-buildJuleModule}

The following is an example expression using `buildJuleModule`:

```nix
buildJuleModule (finalAttrs: {
  pname = "julefmt";
  version = "unstable-2025-10-17";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "julefmt";
    rev = "cc30781206d3d7b88599cc51b3f9d7d7936de527";
    hash = "sha256-g3vN2Hz4BA5c0KqIbNKHg0W77xKGZQFHUIKWjg5/UTM=";
  };

  meta = {
    description = "Official formatter tool for the Jule programming language";
    homepage = "https://manual.jule.dev/tools/julefmt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ adamperkowski ];
  };
})
```

## Attributes of `buildJuleModule` {#buildjulemodule-parameters}

`buildJuleModule` respects the following attributes:

- [`prePatch`](#var-stdenv-prePatch)
- [`patches`](#var-stdenv-patches)
- [`patchFlags`](#var-stdenv-patchFlags)
- [`postPatch`](#var-stdenv-postPatch)
- [`preBuild`](#var-stdenv-preBuild)
- `env`: useful for passing down variables

To control test execution of the build derivation, the following attributes are of interest:

- [`checkInputs`](#var-stdenv-checkInputs)
- [`preCheck`](#var-stdenv-preCheck)

In addition to the above attributes, and the many more variables respected also by `stdenv.mkDerivation`, `buildJuleModule` respects Jule-specific attributes that tweak them to behave slightly differently:

### `srcDir` {#var-jule-srcDir}

Directory containing the main source file (`main.jule`).

Defaults to `./src`.

### `testDir` {#var-jule-testDir}

Directory containing unit tests.

Defaults to [`srcDir`](#var-jule-srcDir).

### `buildArgs` {#var-jule-buildArgs}

List of additional arguments to pass to `julec` during the build phase.

See [JuleC options](https://manual.jule.dev/compiler/compiler-options.html).

Defaults to `[ ]`.

### `checkArgs` {#var-jule-checkArgs}

List of additional arguments to pass to `julec` during the check phase.

See [JuleC options](https://manual.jule.dev/compiler/compiler-options.html).

Defaults to `[ ]`.

## Skipping tests {#ssec-skip-jule-tests}

`buildJuleModule` runs tests by default. To disable all tests, set `doCheck = false;`.
