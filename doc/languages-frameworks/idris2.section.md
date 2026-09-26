# Idris2 {#sec-idris2}

When developing using Idris2, by default the Idris compiler only has the minimal support libraries in its environment. This means that it will not attempt to read any libraries installed
globally, for example in the `$HOME` directory. The recommended way to use Idris2 is to wrap the compiler in an environment that provides these packages per-project, for example in a
devShell.

```nix
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = [ (idris2.withPackages (p: [ p.idris2Api ])) ];
}
```
or, alternatively if Nix is used to build the Idris2 project:

```nix
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  inputsFrom = [ (pkgs.callPackage ./package.nix { }) ];
}
```

By default, the Idris2 compiler provided by Nixpkgs does not read globally installed packages, nor can install them. Running `idris2 --install` will fail because the Nix store is
a read-only file-system. If globally-installed packages are desired rather than the above strategy, one can set `IDRIS2_PREFIX`, or additional `IDRIS2_PACKAGE_PATH` entries
for the compiler to read from. The following snippet will append `$HOME/.idris2` to `$IDRIS2_PACKAGE_PATH`, and if such a variable does not exist, create it. The Nixpkg's Idris2
compiler append a few required libraries to this path variable, but any paths in the user's environment will be prefixed to those libraries.

```nix
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = [ (idris2.withPackages (p: [ p.idris2Api ])) ];
  shellHook = ''
    IDRIS2_PACKAGE_PATH="''${IDRIS2_PACKAGE_PATH:+$IDRIS2_PACKAGE_PATH}$HOME/.idris2"
  '';
}
```
The following snippet will allow the Idris2 to run `idris2 --install` successfully:
```nix
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = [ (idris2.withPackages (p: [ p.idris2Api ])) ];
  shellHook = ''
    IDRIS2_PREFIX="$HOME/.idris2"
  '';
}
```

In addition to exposing the Idris2 compiler itself, Nixpkgs exposes an `idris2Packages.buildIdris` helper to make it a bit more ergonomic to build Idris2 executables or libraries.

The `buildIdris` function takes an attribute set that defines at a minimum the `src` and `ipkgName` of the package to be built and any `idrisLibraries` required to build it. The `src` is the same source you're familiar with and the `ipkgName` must be the name of the `ipkg` file for the project (omitting the `.ipkg` extension). The `idrisLibraries` is a list of other library derivations created with `buildIdris`. You can optionally specify other derivation properties as needed but sensible defaults for `configurePhase`, `buildPhase`, and `installPhase` are provided.

Importantly, `buildIdris` does not create a single derivation but rather an attribute set with two properties: `executable` and `library`. The `executable` property is a derivation and the `library` property is a function that will return a derivation for the library with or without source code included. Source code need not be included unless you are aiming to use IDE or LSP features that are able to jump to definitions within an editor.

A simple example of a fully packaged library would be the [`LSP-lib`](https://github.com/idris-community/LSP-lib) found in the `idris-community` GitHub organization.
```nix
{ fetchFromGitHub, idris2Packages }:
let
  lspLibPkg = idris2Packages.buildIdris {
    ipkgName = "lsp-lib";
    src = fetchFromGitHub {
      owner = "idris-community";
      repo = "LSP-lib";
      rev = "main";
      hash = "sha256-EvSyMCVyiy9jDZMkXQmtwwMoLaem1GsKVFqSGNNHHmY=";
    };
    idrisLibraries = [ ];
  };
in
lspLibPkg.library { withSource = true; }
```

The above results in a derivation with the installed library results (with source code).

A slightly more involved example of a fully packaged executable would be the [`idris2-lsp`](https://github.com/idris-community/idris2-lsp) which is an Idris2 language server that uses the `LSP-lib` found above.
```nix
{
  callPackage,
  fetchFromGitHub,
  idris2Packages,
}:

# Assuming the previous example lives in `lsp-lib.nix`:
let
  lspLib = callPackage ./lsp-lib.nix { };
  inherit (idris2Packages) idris2Api;
  lspPkg = idris2Packages.buildIdris {
    ipkgName = "idris2-lsp";
    src = fetchFromGitHub {
      owner = "idris-community";
      repo = "idris2-lsp";
      rev = "main";
      hash = "sha256-vQTzEltkx7uelDtXOHc6QRWZ4cSlhhm5ziOqWA+aujk=";
    };
    idrisLibraries = [
      idris2Api
      lspLib
    ];
  };
in
lspPkg.executable
```

The above uses the default value of `withSource = false` for the `idris2Api` but could be modified to include that library's source by passing `(idris2Api { withSource = true; })` to `idrisLibraries` instead. `idris2Api` in the above derivation comes built in with `idris2Packages`. This library exposes many of the otherwise internal APIs of the Idris2 compiler.

The compiler package can be instantiated with packages on its `IDRIS2_PACKAGES` path from the `idris2Packages` set.

```nix
{
  idris2,
  devShell,
}:
let
  myIdris = idris2.withPackages (p: [ p.idris2Api ]);
in
devShell {
  packages = [ myIdris ];
}
```

This search path is extended from the path already in the user's environment.
