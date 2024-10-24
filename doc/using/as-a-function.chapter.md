# Nixpkgs as a Function {#sec-nixpkgs-function}

Depending on how you use Nixpkgs, you may interact with it as a [Nix function].
The Nixpkgs function returns an attribute set containing mostly packages, but also other things, such as more package sets, and functions.
This return value is often referred to with the identifier `pkgs`, and it has a marker attribute, `_type = "pkgs";`.

The Nixpkgs function can be retrieved in multiple ways.

In a setup with [Nix channels], you may look up the Nixpkgs files with [`<nixpkgs>`][Nix lookup path]; for example

```console
$ nix repl -f '<nixpkgs>'
Added 21938 variables.
nix-repl>
```

<!-- -f: abbreviated form because it is very frequently used -->
[`nix repl`] [`-f`][`nix repl -f`] automatically imports the Nixpkgs function and invokes it for you.

Most Nix commands accept [`--arg`] and [`--argstr`] options to pass arguments to the Nixpkgs function.

In an expression, you can use the `import <nixpkgs> { }` syntax to import the Nixpkgs function, and immmediately [apply] it.

```nix
let
  pkgs = import <nixpkgs> {
    config = { allowUnfree = true; };
  };
in
```

Note that these examples so far have relied on the implicit, [impure] [`builtins.currentSystem`] variable to configure the package set to be able to run on your system.

If you wish not to accidentally rely on the implicit [`builtins.currentSystem`] variable, and you'd like to avoid configuration in `~/.config/nixpkgs`, you may invoke `<nixpkgs/pkgs/top-level>` instead.

To make sure you can reproduce your evaluations, you may use [pinning] or locking, such as provided by [`npins`] or [Flakes].

## Arguments {#sec-nixpkgs-arguments}

For historical reasons, the platform and cross compilation parameters can be specified in multiple ways.

If you run Nix in pure mode, or if you work with expressions for multiple host platforms, you are recommended to use `hostPlatform` for native compilation (locally or on a remote machine), and both `hostPlatform` and `buildPlatform` for cross compilation.

### `hostPlatform` and `buildPlatform` {#sec-nixpkgs-arguments-platforms}

- `hostPlatform` is the platform for which the package set is built. This means that the binaries in the outputs are compatible with `hostPlatform`.

  You may specify this as a cpu-os string, such as `"x86_64-linux"`, or `aarch64-darwin`, or you can pass a more details platform object produced with `lib.systems`.

- `buildPlatform` (default: `hostPlatform`) is the platform on which the derivations will run. The derivations produced by Nixpkgs will have a [`system` attribute] that matches `buildPlatform`, so that builds are sent to a machine that is capable of running the `builder` command, which is also configured to be compatible with `buildPlatform`.

  Values are specified in the same formats as `hostPlatform`.

::: {.example #ex-nixpkgs-pure-native}

# Natively compiled packages

This shows how to explicitly request packages that are built for a specific platform, not relying on [`builtins.currentSystem`].
The packages will be built natively.

If you request to build this on a host that is not compatible, you need a remote builder.

```nix
let
  pkgs = imports <nixpkgs> {
    hostPlatform = "x86_64-linux";
  };
in pkgs.hello
```

:::

::: {.example #ex-nixpkgs-pure-cross}

# Cross compiled packages

This expression will produce packages that are built on `x86_64-linux` machines, but whose outputs can run on `riscv64-linux`.

The expression is pure, so it will produce the same outcome even if run on e.g. an `aarch64-darwin` machine. For that to work, the macOS machine needs the packages to be available in a cache or it needs a remote builder that can build `x86_64-linux` derivations.

If you were to use [`builtins.currentSystem`] for `buildPlatform`, you would be able to build the packages directly on any machine, but the resulting store paths will be different, depending on the current system.
Especially if you are in a team that doesn't run a single CPU architecture and operating system or you use Nix on machines of more than one platform, you might notice that equivalent deployments would have different store paths, resulting in unnecessary rebuilds, more store path copying, and unnecessary updates to equivalent configurations with different `buildPlatform`s.
For these reason, it is recommended to use pure configurations where the platform parameters are set to fixed values for each deployment target.

```nix
let
  pkgs = imports <nixpkgs> {
    hostPlatform = "riscv64-linux";
    buildPlatform = "x86_64-linux";
  };
in pkgs.hello
```

:::

### Legacy arguments `system`, `localSystem` and `crossSystem` {#sec-nixpkgs-arguments-systems-legacy}

`crossSystem` and `system` (or `localSystem`) are ok to use on the command line, but are not recommended for pure Nix code (such as Nix flakes), or Nix code that manages the invocation of the Nixpkgs function.

These parameters existed before [`hostPlatform` and `buildPlatform`](#sec-nixpkgs-arguments-platforms) were introduced.
They are still supported, but are not recommended for new code.

The main difference is that these parameters default to [`builtins.currentSystem`], which does not work for pure code.

Furthermore, their design is optimized for impure command line use.

The term "local" is misleading, because it need not match the platform where the Nix command is run.

The term "cross" is also misleading because its value may equal `localSystem`.

Finally `crossSystem` may have to be unset as an input, complicating some code that calls the Nixpkgs function.
<!-- This example transgresses the guidelines a bit, but we have an audience here that needs answers, because who likes change. Without explanation, this comes across as a superficial, unnecessary and annoying change. Remove this example in 2026 when it is irrelevant. -->
For example, [`nixos-generate-config`] wasn't initially able to set the platform in `hardware-configuration.nix` without making assumptions about cross versus native compilation, resulting in a need for you to manually specify `system` when Flakes were introduced.

### `config` {#sec-nixpkgs-arguments-config}

Example:

```nix
import <nixpkgs> { config = { allowUnfree = true; }; }
```

See [Configuration](#sec-config-options-reference) for details.

### `overlays` {#sec-nixpkgs-arguments-overlays}

Overlays are expressions that modify the package set.

See [Overlays](#chap-overlays) for more information.

### `crossOverlays` {#sec-nixpkgs-arguments-crossOverlays}

<!-- Source: https://matthewbauer.us/slides/always-be-cross-compiling.pdf -->
Cross overlays apply only to the final package set in cross compilation.
This means that [`buildPackages`] and [`nativeBuildInputs`] are unaffected by these overlays and this increases the number of build dependencies that can be retrieved from the cache, or can be reused from a previous build.

[Nix function]: https://nix.dev/manual/nix/latest/language/constructs.html#functions
[Nix channels]: https://nix.dev/manual/nix/latest/command-ref/nix-channel.html
[Nix lookup path]: https://nix.dev/manual/nix/latest/language/constructs/lookup-path.html
[`builtins.currentSystem`]: https://nix.dev/manual/nix/latest/language/builtin-constants.html#builtins-currentSystem
[`system` attribute]: https://nix.dev/manual/nix/latest/language/derivations#attr-system
[`--arg`]: https://nix.dev/manual/nix/latest/command-ref/opt-common.html?highlight=--arg#opt-arg
[`--argstr`]: https://nix.dev/manual/nix/latest/command-ref/opt-common.html?highlight=--argstr#opt-argstr
[apply]: https://nix.dev/manual/nix/latest/language/operators
[impure]: https://nix.dev/manual/nix/latest/command-ref/conf-file.html?highlight=pure-eval#conf-pure-eval
[`npins`]: https://nix.dev/guides/recipes/dependency-management.html
[Flakes]: https://nix.dev/concepts/flakes.html#flakes
[pinning]: https://nix.dev/reference/pinning-nixpkgs.html
<!-- TODO: publish NixOS man pages -->
[`nixos-generate-config`]: https://nixos.org/manual/nixos/stable/#sec-installation
<!-- TODO: make more specific -->
[`buildPackages`]: #ssec-cross-dependency-implementation
<!-- TODO: make more specific -->
[`nativeBuildInputs`]: #ssec-stdenv-dependencies-propagated
[`nix repl`]: https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-repl.html
[`nix repl -f`]: https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-repl?highlight=--file#opt-file
