# Go {#sec-language-go}

## Go modules {#ssec-language-go}

The function `buildGoModule` builds Go programs managed with Go modules. It builds a [Go Modules](https://github.com/golang/go/wiki/Modules) through a two phase build:

- An intermediate fetcher derivation. This derivation will be used to fetch all the dependencies of the Go module. It is passed to the main derivation as an attribute named `go-modules`.

- A final derivation will use the output of the intermediate derivation to build the binaries and produce the final output.

`buildGoModule` takes a fixed-point function or an attribute set.

### Examples for `buildGoModule` {#ex-buildGoModule}

In the following is an example expression using `buildGoModule`, the following attributes are of special significance to the function:

- `vendorHash`: is the hash of the output of the intermediate fetcher derivation.

  `vendorHash` can also be set to `null`.
  In that case, rather than fetching the dependencies and vendoring them, the dependencies vendored in the source repo will be used.

  To avoid updating this field when dependencies change, run `go mod vendor` in your source repo and set `vendorHash = null;`

- `proxyVendor`: Fetches (go mod download) and proxies the vendor directory. This is useful if your code depends on c code and go mod tidy does not include the needed sources to build or if any dependency has case-insensitive conflicts which will produce platform-dependent `vendorHash` checksums.

- `modPostBuild`: Shell commands to run after the build of the go-modules executes `go mod vendor`, and before calculating fixed output derivation's `vendorHash` (or `vendorSha256`). Note that if you change this attribute, you need to update `vendorHash` (or `vendorSha256`) attribute.

```nix
pet = buildGoModule (finalAttrs: {
  pname = "pet";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Gjw1dRrgM8D3G7v6WIM2+50r4HmTXvx0Xxme2fH9TlQ=";
  };

  vendorHash = "sha256-ciBIR+a1oaYH+H1PcC8cD8ncfJczk1IiJ8iYNM+R6aA=";

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
})
```

### Obtaining and overriding `vendorHash` for `buildGoModule` {#vendorHash-buildGoModule}

`nix-prefetch` can be used to obtain the actual hash. The following command gets the value of `vendorHash` for package `pet`:

```sh
cd path/to/nixpkgs
nix-prefetch -E "{ sha256 }: ((import ./. { }).my-package.overrideAttrs (_: { vendorHash = sha256; })).go-modules"
```

To obtain the hash without external tools, set `vendorHash = lib.fakeSha256;` and run the build. ([more details here](#sec-source-hashes)).

`vendorHash` can be overridden with `overrideAttrs`. The above example package can be overridden like this:

```nix
pet_4_0 = pet.overrideAttrs (finalAttrs: previousAttrs: {
  version = "0.4.0";

  src = fetchFromGitHub {
    # Note: If rev isn't specified using `finalAttrs.version` in the original package expression,
    # `rev` needs to be specified again instead of inheriting.
    inherit (previousAttrs.src) owner repo rev;
    hash = "sha256-gVTpzmXekQxGMucDKskGi+e+34nJwwsXwvQTjRO6Gdg=";
  };

  vendorHash = "sha256-dUvp7FEW09V0xMuhewPGw3TuAic/sD7xyXEYviZ2Ivs=";
})
```

### Customizing `buildGoModule` phases {#customize-buildGoModule}

`buildGoModule` implements the `configurePhase`, `buildPhase`, `checkPhase` and `installPhase` to pass to `stdenv.mkDerivation`. The `configurePhase` are especially significant as it injects the `go-modules` into the build process.

Most customization can be done via the corresponding `pre*` and `post*` phases without specifying the `*Phase` directly. If any of these `*Phase` are specified directly, however, the one provided by `buildGoModule` will be overwritten. This might be intended if the build process isn't done directly through `go install` and/or `go test`.

## `buildGoPackage` (legacy) {#ssec-go-legacy}

The function `buildGoPackage` builds legacy Go programs, not supporting Go modules.

### Example for `buildGoPackage` {#example-for-buildgopackage}

In the following is an example expression using buildGoPackage, the following arguments are of special significance to the function:

- `goPackagePath` specifies the package's canonical Go import path.
- `goDeps` is where the Go dependencies of a Go program are listed as a list of package source identified by Go import path. It could be imported as a separate `deps.nix` file for readability. The dependency data structure is described below.

```nix
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

To extract dependency information from a Go package in automated way use [go2nix](https://github.com/kamilchm/go2nix). It can produce complete derivation and `goDeps` file for Go programs.

You may use Go packages installed into the active Nix profiles by adding the following to your ~/.bashrc:

```bash
for p in $NIX_PROFILES; do
    GOPATH="$p/share/go:$GOPATH"
done
```

## Attributes used by the builders {#ssec-go-common-attributes}

Many attributes [controlling the build phase](#variables-controlling-the-build-phase) are respected by both `buildGoModule` and `buildGoPackage`. Note that `buildGoModule` reads the following attributes also when building the `vendor/` go-modules fixed output derivation as well:

- [`sourceRoot`](#var-stdenv-sourceRoot)
- [`prePatch`](#var-stdenv-prePatch)
- [`patches`](#var-stdenv-patches)
- [`patchFlags`](#var-stdenv-patchFlags)
- [`postPatch`](#var-stdenv-postPatch)
- [`preBuild`](#var-stdenv-preBuild)

In addition to the above attributes, and the many more variables respected also by `stdenv.mkDerivation`, both `buildGoModule` and `buildGoPackage` respect Go-specific attributes that tweak them to behave slightly differently:

### `ldflags` {#var-go-ldflags}

Arguments to pass to the Go linker tool via the `-ldflags` argument of `go build`. The most common use case for this argument is to make the resulting executable aware of its own version. For example:

```nix
  ldflags = [
    "-s" "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
  ];
```

### `tags` {#var-go-tags}

Arguments to pass to the Go via the `-tags` argument of `go build`. For example:

```nix
  tags = [
    "production"
    "sqlite"
  ];
```

```nix
  tags = [ "production" ] ++ lib.optionals withSqlite [ "sqlite" ];
```

### `deleteVendor` {#var-go-deleteVendor}

Removes the pre-existing vendor directory. This should only be used if the dependencies included in the vendor folder are broken or incomplete.

### `subPackages` {#var-go-subPackages}

Specified as a string or list of strings. Limits the builder from building child packages that have not been listed. If `subPackages` is not specified, all child packages will be built.

### `excludedPackages` {#var-go-excludedPackages}

Specified as a string or list of strings. Causes the builder to skip building child packages that match any of the provided values. If `excludedPackages` is not specified, all child packages will be built.
