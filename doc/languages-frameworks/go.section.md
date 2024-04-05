# Go {#sec-language-go}

## Building Go modules with `buildGoModule` {#ssec-language-go}

The function `buildGoModule` builds Go programs managed with Go modules. It builds [Go Modules](https://github.com/golang/go/wiki/Modules) through a two phase build:

- An intermediate fetcher derivation called `goModules`. This derivation will be used to fetch all the dependencies of the Go module.
- A final derivation will use the output of the intermediate derivation to build the binaries and produce the final output.

### Attributes of `buildGoModule` {#buildgomodule-parameters}

The `buildGoModule` function accepts the following parameters in addition to the [attributes accepted by both Go builders](#ssec-go-common-attributes):

- `vendorHash`: is the hash of the output of the intermediate fetcher derivation (the dependencies of the Go modules).

  `vendorHash` can be set to `null`.
  In that case, rather than fetching the dependencies, the dependencies already vendored in the `vendor` directory of the source repo will be used.

  To avoid updating this field when dependencies change, run `go mod vendor` in your source repo and set `vendorHash = null;`.
  You can read more about [vendoring in the Go documentation](https://go.dev/ref/mod#vendoring).

  To obtain the actual hash, set `vendorHash = lib.fakeHash;` and run the build ([more details here](#sec-source-hashes)).
- `proxyVendor`: If `true`, the intermediate fetcher downloads dependencies from the
  [Go module proxy](https://go.dev/ref/mod#module-proxy) (using `go mod download`) instead of vendoring them. The resulting
  [module cache](https://go.dev/ref/mod#module-cache) is then passed to the final derivation.

  This is useful if your code depends on C code and `go mod tidy` does not include the needed sources to build or
  if any dependency has case-insensitive conflicts which will produce platform-dependent `vendorHash` checksums.

  Defaults to `false`.
- `modPostBuild`: Shell commands to run after the build of the goModules executes `go mod vendor`, and before calculating fixed output derivation's `vendorHash`.
  Note that if you change this attribute, you need to update `vendorHash` attribute.
- `modRoot`: The root directory of the Go module that contains the `go.mod` file.
  Defaults to `./`, which is the root of `src`.

### Example for `buildGoModule` {#ex-buildGoModule}

The following is an example expression using `buildGoModule`:

```nix
{
  pet = buildGoModule rec {
    pname = "pet";
    version = "0.3.4";

    src = fetchFromGitHub {
      owner = "knqyf263";
      repo = "pet";
      rev = "v${version}";
      hash = "sha256-Gjw1dRrgM8D3G7v6WIM2+50r4HmTXvx0Xxme2fH9TlQ=";
    };

    vendorHash = "sha256-ciBIR+a1oaYH+H1PcC8cD8ncfJczk1IiJ8iYNM+R6aA=";

    meta = {
      description = "Simple command-line snippet manager, written in Go";
      homepage = "https://github.com/knqyf263/pet";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ kalbasit ];
    };
  };
}
```

## `buildGoPackage` (legacy) {#ssec-go-legacy}

The function `buildGoPackage` builds legacy Go programs, not supporting Go modules.

### Example for `buildGoPackage` {#example-for-buildgopackage}

In the following is an example expression using `buildGoPackage`, the following arguments are of special significance to the function:

- `goPackagePath` specifies the package's canonical Go import path.
- `goDeps` is where the Go dependencies of a Go program are listed as a list of package source identified by Go import path. It could be imported as a separate `deps.nix` file for readability. The dependency data structure is described below.

```nix
{
  deis = buildGoPackage rec {
    pname = "deis";
    version = "1.13.0";

    goPackagePath = "github.com/deis/deis";

    src = fetchFromGitHub {
      owner = "deis";
      repo = "deis";
      rev = "v${version}";
      hash = "sha256-XCPD4LNWtAd8uz7zyCLRfT8rzxycIUmTACjU03GnaeM=";
    };

    goDeps = ./deps.nix;
  };
}
```

The `goDeps` attribute can be imported from a separate `nix` file that defines which Go libraries are needed and should be included in `GOPATH` for `buildPhase`:

```nix
# deps.nix
[ # goDeps is a list of Go dependencies.
  {
    # goPackagePath specifies Go package import path.
    goPackagePath = "gopkg.in/yaml.v2";
    fetch = {
      # `fetch type` that needs to be used to get package source.
      # If `git` is used there should be `url`, `rev` and `hash` defined next to it.
      type = "git";
      url = "https://gopkg.in/yaml.v2";
      rev = "a83829b6f1293c91addabc89d0571c246397bbf4";
      hash = "sha256-EMrdy0M0tNuOcITaTAmT5/dPSKPXwHDKCXFpkGbVjdQ=";
    };
  }
  {
    goPackagePath = "github.com/docopt/docopt-go";
    fetch = {
      type = "git";
      url = "https://github.com/docopt/docopt-go";
      rev = "784ddc588536785e7299f7272f39101f7faccc3f";
      hash = "sha256-Uo89zjE+v3R7zzOq/gbQOHj3SMYt2W1nDHS7RCUin3M=";
    };
  }
]
```

To extract dependency information from a Go package in automated way use [go2nix (deprecated)](https://github.com/kamilchm/go2nix). It can produce complete derivation and `goDeps` file for Go programs.

You may use Go packages installed into the active Nix profiles by adding the following to your ~/.bashrc:

```bash
for p in $NIX_PROFILES; do
    GOPATH="$p/share/go:$GOPATH"
done
```

## Attributes used by both builders {#ssec-go-common-attributes}

Many attributes [controlling the build phase](#variables-controlling-the-build-phase) are respected by both `buildGoModule` and `buildGoPackage`. Note that `buildGoModule` reads the following attributes also when building the `vendor/` goModules fixed output derivation as well:

- [`sourceRoot`](#var-stdenv-sourceRoot)
- [`prePatch`](#var-stdenv-prePatch)
- [`patches`](#var-stdenv-patches)
- [`patchFlags`](#var-stdenv-patchFlags)
- [`postPatch`](#var-stdenv-postPatch)
- [`preBuild`](#var-stdenv-preBuild)

To control test execution of the build derivation, the following attributes are of interest:

- [`checkInputs`](#var-stdenv-checkInputs)
- [`preCheck`](#var-stdenv-preCheck)
- [`checkFlags`](#var-stdenv-checkFlags)

In addition to the above attributes, and the many more variables respected also by `stdenv.mkDerivation`, both `buildGoModule` and `buildGoPackage` respect Go-specific attributes that tweak them to behave slightly differently:

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
{
  tags = [ "production" ] ++ lib.optionals withSqlite [ "sqlite" ];
}
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

### `CGO_ENABLED` {#var-go-CGO_ENABLED}

When set to `0`, the [cgo](https://pkg.go.dev/cmd/cgo) command is disabled. As consequence, the build
program can't link against C libraries anymore, and the resulting binary is statically linked.

When building with CGO enabled, Go will likely link some packages from the Go standard library against C libraries,
even when the target code does not explicitly call into C dependencies. With `CGO_ENABLED = 0;`, Go
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

`CGO_ENABLED` defaults to `1`.

### `enableParallelBuilding` {#var-go-enableParallelBuilding}

Whether builds and tests should run in parallel.

Defaults to `true`.

### `allowGoReference` {#var-go-allowGoReference}

Whether the build result should be allowed to contain references to the Go tool chain. This might be needed for programs that are coupled with the compiler, but shouldn't be set without a good reason.

Defaults to `false`

## Controlling the Go environment {#ssec-go-environment}

The Go build can be further tweaked by setting environment variables. In most cases, this isn't needed. Possible values can be found in the [Go documentation of accepted environment variables](https://pkg.go.dev/cmd/go#hdr-Environment_variables). Notice that some of these flags are set by the builder itself and should not be set explicitly. If in doubt, grep the implementation of the builder.

## Skipping tests {#ssec-skip-go-tests}

`buildGoModule` runs tests by default. Failing tests can be disabled using the `checkFlags` parameter.
This is done with the [`-skip` or `-run`](https://pkg.go.dev/cmd/go#hdr-Testing_flags) flags of the `go test` command.

For example, only a selection of tests could be run with:

```nix
{
  # -run and -skip accept regular expressions
  checkFlags = [
    "-run=^Test(Simple|Fast)$"
  ];
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
`buildGoPackage` does not execute tests by default.
