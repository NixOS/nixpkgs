# Package your first application {#chap-first-package}

Package an application with Nixpkgs by picking the build helper for its language and setting a few attributes.

Each language ecosystem has its own build helper.
See [](#chap-language-support) for the full set.

## Package a Go application {#first-package-go}

`buildGoModule` builds Go programs that use Go modules.

Write the package to `package.nix`:

:::{.example #ex-first-package-go}

# Package `pet` with `buildGoModule`

```nix
# package.nix
{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "pet";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gjw1dRrgM8D3G7v6WIM2+50r4HmTXvx0Xxme2fH9TlQ=";
  };

  vendorHash = "sha256-6hCgv2/8UIRHw1kCe3nLkxF23zE/7t5RDwEjSzX3pBQ=";

  meta = {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/knqyf263/pet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
})
```

:::

`buildGoModule` needs `pname`, `version`, `src`, and `vendorHash`.

Pin Nixpkgs and call the package from `default.nix`:

```nix
# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  pkgs = import nixpkgs { };
in
pkgs.callPackage ./package.nix { }
```

Build it:

```shell
$ nix-build ./default.nix
# or equivalent
$ nix-build
```

Run it:

```shell
$ ./result/bin/pet --help
pet - Simple command-line snippet manager.
```

`vendorHash` pins the fetched dependencies.
To find its value:

1. Set `vendorHash` to an empty string `""`.
2. Run `nix-build`.
3. Copy the correct value from the error into `vendorHash`.

See the [Go reference](#sec-language-go) for every attribute and advanced usage.
