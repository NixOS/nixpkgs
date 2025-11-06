# Go {#sec-language-go}

## Building Go modules with `buildGoModule` {#ssec-language-go}

The function `buildGoModule` builds Go programs managed with Go modules. It builds [Go Modules](https://go.dev/wiki/Modules) through a two phase build:

- An intermediate fetcher derivation called `goModules`. This derivation will be used to fetch all the dependencies of the Go module.
- A final derivation will use the output of the intermediate derivation to build the binaries and produce the final output.

### Example for `buildGoModule` {#ex-buildGoModule}

The following is an example expression using `buildGoModule`:

```nix
{
  pet = buildGoModule (finalAttrs: {
    pname = "pet";
    version = "0.3.4";

    src = fetchFromGitHub {
      owner = "knqyf263";
      repo = "pet";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Gjw1dRrgM8D3G7v6WIM2+50r4HmTXvx0Xxme2fH9TlQ=";
    };

    vendorHash = "sha256-ciBIR+a1oaYH+H1PcC8cD8ncfJczk1IiJ8iYNM+R6aA=";

    meta = {
      description = "Simple command-line snippet manager, written in Go";
      homepage = "https://github.com/knqyf263/pet";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ kalbasit ];
    };
  });
}
```

## Attributes of `buildGoModule` {#buildgomodule-parameters}

Many attributes [controlling the build phase](#variables-controlling-the-build-phase) are respected by `buildGoModule`. Note that `buildGoModule` reads the following attributes also when building the `vendor/` goModules fixed output derivation as well:

- [`sourceRoot`](#var-stdenv-sourceRoot)
- [`prePatch`](#var-stdenv-prePatch)
- [`patches`](#var-stdenv-patches)
- [`patchFlags`](#var-stdenv-patchFlags)
- [`postPatch`](#var-stdenv-postPatch)
- [`preBuild`](#var-stdenv-preBuild)
- `env`: useful for passing down variables such as `GOWORK`.

To control test execution of the build derivation, the following attributes are of interest:

- [`checkInputs`](#var-stdenv-checkInputs)
- [`preCheck`](#var-stdenv-preCheck)
- [`checkFlags`](#var-stdenv-checkFlags)

In addition to the above attributes, and the many more variables respected also by `stdenv.mkDerivation`, `buildGoModule` respects Go-specific attributes that tweak them to behave slightly differently:

### `vendorHash` {#var-go-vendorHash}

Hash of the output of the intermediate fetcher derivation (the dependencies of the Go modules).

`vendorHash` can be set to `null`.
In that case, rather than fetching the dependencies, the dependencies already vendored in the `vendor` directory of the source repo will be used.

To avoid updating this field when dependencies change, run `go mod vendor` in your source repo and set `vendorHash = null;`.
You can read more about [vendoring in the Go documentation](https://go.dev/ref/mod#vendoring).

To obtain the hash, set `vendorHash = lib.fakeHash;` and run the build. ([more details here](#sec-source-hashes)).
Another way is to use `nix-prefetch` to obtain the hash. The following command gets the value of `vendorHash` for package `pet`:


```sh
cd path/to/nixpkgs
nix-prefetch -E "{ sha256 }: ((import ./. { }).my-package.overrideAttrs { vendorHash = sha256; }).goModules"
```

`vendorHash` can be overridden with `overrideAttrs`. Override the above example like this:

```nix
{
  pet_0_4_0 = pet.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "0.4.0";
      src = fetchFromGitHub {
        inherit (previousAttrs.src) owner repo;
        rev = "v${finalAttrs.version}";
        hash = "sha256-gVTpzmXekQxGMucDKskGi+e+34nJwwsXwvQTjRO6Gdg=";
      };
      vendorHash = "sha256-dUvp7FEW09V0xMuhewPGw3TuAic/sD7xyXEYviZ2Ivs=";
    }
  );
}
```

### `proxyVendor` {#var-go-proxyVendor}

If `true`, the intermediate fetcher downloads dependencies from the
[Go module proxy](https://go.dev/ref/mod#module-proxy) (using `go mod download`) instead of vendoring them. The resulting
[module cache](https://go.dev/ref/mod#module-cache) is then passed to the final derivation.

This is useful if your code depends on C code and `go mod tidy` does not include the needed sources to build or
if any dependency has case-insensitive conflicts which will produce platform-dependent `vendorHash` checksums.

Defaults to `false`.


### `modPostBuild` {#var-go-modPostBuild}

Shell commands to run after the build of the goModules executes `go mod vendor`, and before calculating fixed output derivation's `vendorHash`.
Note that if you change this attribute, you need to update the `vendorHash` attribute.


### `modRoot` {#var-go-modRoot}

The root directory of the Go module that contains the `go.mod` file.

Defaults to `./`, which is the root of `src`.

### `ldflags` {#var-go-ldflags}

A string list of flags to pass to the Go linker tool via the `-ldflags` argument of `go build`. Possible values can be retrieved by running `go tool link --help`.
The most common use case for this argument is to make the resulting executable aware of its own version by injecting the value of string variable using the `-X` flag. For example:

```nix
{
  ldflags = [
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
  ];
}
```

### `tags` {#var-go-tags}

A string list of [Go build tags (also called build constraints)](https://pkg.go.dev/cmd/go#hdr-Build_constraints) that are passed via the `-tags` argument of `go build`.  These constraints control whether Go files from the source should be included in the build. For example:

```nix
{
  tags = [
    "production"
    "sqlite"
  ];
}
```

Tags can also be set conditionally:

```nix
{ tags = [ "production" ] ++ lib.optionals withSqlite [ "sqlite" ]; }
```

### `deleteVendor` {#var-go-deleteVendor}

If set to `true`, removes the pre-existing vendor directory. This should only be used if the dependencies included in the vendor folder are broken or incomplete.

### `subPackages` {#var-go-subPackages}

Specified as a string or list of strings. Limits the builder from building child packages that have not been listed. If `subPackages` is not specified, all child packages will be built.

Many Go projects keep the main package in a `cmd` directory.
Following example could be used to only build the example-cli and example-server binaries:

```nix
{
  subPackages = [
    "cmd/example-cli"
    "cmd/example-server"
  ];
}
```

### `excludedPackages` {#var-go-excludedPackages}

Specified as a string or list of strings. Causes the builder to skip building child packages that match any of the provided values.

### `enableParallelBuilding` {#var-go-enableParallelBuilding}

Whether builds and tests should run in parallel.

Defaults to `true`.

### `allowGoReference` {#var-go-allowGoReference}

Whether the build result should be allowed to contain references to the Go tool chain. This might be needed for programs that are coupled with the compiler, but shouldn't be set without a good reason.

Defaults to `false`

### `goSum` {#var-go-goSum}

Specifies the contents of the `go.sum` file and triggers rebuilds when it changes. This helps combat inconsistent dependency errors on `go.sum` changes.

Defaults to `null`

### `buildTestBinaries` {#var-go-buildTestBinaries}

This option allows to compile test binaries instead of the usual binaries produced by a package.
Go can [compile test into binaries](https://pkg.go.dev/cmd/go#hdr-Test_packages) using the `go test -c` command.
These binaries can then be executed at a later point (outside the Nix sandbox) to run the tests.
This is mostly useful for downstream consumers to run integration or end-to-end tests that won't work in the Nix sandbox, for example because they require network access.

## Versioned toolchains and builders {#ssec-go-toolchain-versions}

Beside `buildGoModule`, there are also versioned builders available that pin a specific Go version, like `buildGo124Module` for Go 1.24.
Similar, versioned toolchains are available, like `go_1_24` for Go 1.24.
Both builder and toolchain of a certain version will be removed as soon as the Go version reaches its end of life.

As toolchain updates in nixpkgs cause mass rebuilds and must go through the staging cycle, it can take a while until a new Go minor version is available to consumers of nixpkgs.
If you want quicker access to the latest minor, use `go_latest` toolchain and `buildGoLatestModule` builder.
To learn more about the Go maintenance and upgrade procedure in nixpkgs, check out the [Go toolchain/builder upgrade policy](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/README.md#go-toolchainbuilder-upgrade-policy).

::: {.warning}
The use of `go_latest` and `buildGoLatestModule` is restricted within nixpkgs.
The [Go toolchain/builder upgrade policy](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/README.md#go-toolchainbuilder-upgrade-policy) must be followed.
:::

## Overriding `goModules` {#buildGoModule-goModules-override}

Overriding `<pkg>.goModules` by calling `goModules.overrideAttrs` is unsupported. Still, it is possible to override the `vendorHash` (`goModules`'s `outputHash`) and the `pre`/`post` hooks for both the build and patch phases of the primary and `goModules` derivation.

Alternatively, the primary derivation provides an overridable `passthru.overrideModAttrs` function to store the attribute overlay implicitly taken by `goModules.overrideAttrs`. Here's an example usage of `overrideModAttrs`:

```nix
{
  pet-overridden = pet.overrideAttrs (
    finalAttrs: previousAttrs: {
      passthru = previousAttrs.passthru // {
        # If the original package has an `overrideModAttrs` attribute set, you'd
        # want to extend it, and not replace it. Hence we use
        # `lib.composeExtensions`. If you are sure the `overrideModAttrs` of the
        # original package trivially does nothing, you can safely replace it
        # with your own by not using `lib.composeExtensions`.
        overrideModAttrs = lib.composeExtensions previousAttrs.passthru.overrideModAttrs (
          finalModAttrs: previousModAttrs: {
            # goModules-specific overriding goes here
            postBuild = ''
              # Here you have access to the `vendor` directory.
              substituteInPlace vendor/github.com/example/repo/file.go \
                --replace-fail "panic(err)" ""
            '';
          }
        );
      };
    }
  );
}
```

## Controlling the Go environment {#ssec-go-environment}

The Go build can be further tweaked by setting environment variables via the `env` attribute. In most cases, this isn't needed. Possible values can be found in the [Go documentation of accepted environment variables](https://pkg.go.dev/cmd/go#hdr-Environment_variables). Notice that some of these flags are set by the build helper itself and should not be set explicitly. If in doubt, grep the implementation of the build helper.

`buildGoModule` officially supports the following environment variables:

### `env.CGO_ENABLED` {#var-go-CGO_ENABLED}

When set to `0`, the [cgo](https://pkg.go.dev/cmd/cgo) command is disabled. As a consequence, the build
program can't link against C libraries anymore, and the resulting binary is statically linked.

When building with CGO enabled, Go will likely link some packages from the Go standard library against C libraries,
even when the target code does not explicitly call into C dependencies. With `env.CGO_ENABLED = 0;`, Go
will always use the Go native implementation of these internal packages. For reference see
[net](https://pkg.go.dev/net#hdr-Name_Resolution) and [os/user](https://pkg.go.dev/os/user#pkg-overview) packages.
Notice that the decision whether these packages should use native Go implementation or not can also be controlled
on a per package level using build tags (`tags`). In case CGO is disabled, these tags have no additional effect.

When a Go program depends on C libraries, place those dependencies in `buildInputs`:

```nix
{
  buildInputs = [
    libvirt
    libxml2
  ];
}
```

`env.CGO_ENABLED` defaults to `1`.

## Skipping tests {#ssec-skip-go-tests}

`buildGoModule` runs tests by default. Failing tests can be disabled using the `checkFlags` parameter.
This is done with the [`-skip` or `-run`](https://pkg.go.dev/cmd/go#hdr-Testing_flags) flags of the `go test` command.

For example, only a selection of tests could be run with:

```nix
{
  # -run and -skip accept regular expressions
  checkFlags = [ "-run=^Test(Simple|Fast)$" ];
}
```

If a larger amount of tests should be skipped, the following pattern can be used:

```nix
{
  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestNetwork"
        "TestDatabase/with_mysql" # exclude only the subtest
        "TestIntegration"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];
}
```

To disable tests altogether, set `doCheck = false;`.

## Migrating from `buildGoPackage` to `buildGoModule` {#buildGoPackage-migration}

::: {.warning}
`buildGoPackage` was removed for the 25.05 release. It was used to build legacy Go programs
that do not support Go modules.
:::

Go modules, released 6y ago, are now widely adopted in the ecosystem.
Most upstream projects are using Go modules, and the tooling previously used for dependency management in Go is mostly deprecated, archived or at least unmaintained at this point.

In case a project doesn't have external dependencies or dependencies are vendored in a way understood by `go mod init`, migration can be done with a few changes in the package.

- Switch the builder from `buildGoPackage` to `buildGoModule`
- Remove `goPackagePath` and other attributes specific to `buildGoPackage`
- Set `vendorHash = null;`
- Run `go mod init <module name>` in `postPatch`

In case the package has external dependencies that aren't vendored or the build setup is more complex the upstream source might need to be patched.
Examples for the migration can be found in the [issue tracking migration within nixpkgs](https://github.com/NixOS/nixpkgs/issues/318069).
