# Go {#sec-language-go}

## Go modules {#ssec-language-go}

The function `buildGoModule` builds Go programs managed with Go modules. It builds a [Go Modules](https://github.com/golang/go/wiki/Modules) through a two phase build:

- An intermediate fetcher derivation. This derivation will be used to fetch all of the dependencies of the Go module.
- A final derivation will use the output of the intermediate derivation to build the binaries and produce the final output.

### Example for `buildGoModule` {#ex-buildGoModule}

In the following is an example expression using `buildGoModule`, the following arguments are of special significance to the function:

- `vendorHash`: is the hash of the output of the intermediate fetcher derivation. `vendorHash` can also take `null` as an input. When `null` is used as a value, rather than fetching the dependencies and vendoring them, we use the vendoring included within the source repo. If you'd like to not have to update this field on dependency changes, run `go mod vendor` in your source repo and set `vendorHash = null;`
- `proxyVendor`: Fetches (go mod download) and proxies the vendor directory. This is useful if your code depends on c code and go mod tidy does not include the needed sources to build or if any dependency has case-insensitive conflicts which will produce platform dependant `vendorHash` checksums.

```nix
pet = buildGoModule rec {
  pname = "pet";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "0m2fzpqxk7hrbxsgqplkg7h2p7gv6s1miymv3gvw0cz039skag0s";
  };

  vendorHash = "sha256-ciBIR+a1oaYH+H1PcC8cD8ncfJczk1IiJ8iYNM+R6aA=";

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
```

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
    sha256 = "1qv9lxqx7m18029lj8cw3k7jngvxs4iciwrypdy0gd2nnghc68sw";
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
      # If `git` is used there should be `url`, `rev` and `sha256` defined next to it.
      type = "git";
      url = "https://gopkg.in/yaml.v2";
      rev = "a83829b6f1293c91addabc89d0571c246397bbf4";
      sha256 = "1m4dsmk90sbi17571h6pld44zxz7jc4lrnl4f27dpd1l8g5xvjhh";
    };
  }
  {
    goPackagePath = "github.com/docopt/docopt-go";
    fetch = {
      type = "git";
      url = "https://github.com/docopt/docopt-go";
      rev = "784ddc588536785e7299f7272f39101f7faccc3f";
      sha256 = "0wwz48jl9fvl1iknvn9dqr4gfy1qs03gxaikrxxp9gry6773v3sj";
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

Both `buildGoModule` and `buildGoPackage` can be tweaked to behave slightly differently, if the following attributes are used:

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
