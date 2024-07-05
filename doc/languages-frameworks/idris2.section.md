# Idris2 {#sec-idris2}

In addition to exposing the Idris2 compiler itself, Nixpkgs exposes an `idris2Packages.buildIdris` helper to make it a bit more ergonomic to build Idris2 executables or libraries.

The `buildIdris` function takes an attribute set that defines at a minimum the `src` and `ipkgName` of the package to be built and any `idrisLibraries` required to build it. The `src` is the same source you're familiar with and the `ipkgName` must be the name of the `ipkg` file for the project (omitting the `.ipkg` extension). The `idrisLibraries` is a list of other library derivations created with `buildIdris`. You can optionally specify other derivation properties as needed but sensible defaults for `configurePhase`, `buildPhase`, and `installPhase` are provided.

Importantly, `buildIdris` does not create a single derivation but rather an attribute set with two properties: `executable` and `library`. The `executable` property is a derivation and the `library` property is a function that will return a derivation for the library with or without source code included. Source code need not be included unless you are aiming to use IDE or LSP features that are able to jump to definitions within an editor.

A simple example of a fully packaged library would be the [`LSP-lib`](https://github.com/idris-community/LSP-lib) found in the `idris-community` GitHub organization.
```nix
{ fetchFromGitHub, idris2Packages }:
let lspLibPkg = idris2Packages.buildIdris {
  ipkgName = "lsp-lib";
  src = fetchFromGitHub {
   owner = "idris-community";
   repo = "LSP-lib";
   rev = "main";
   hash = "sha256-EvSyMCVyiy9jDZMkXQmtwwMoLaem1GsKVFqSGNNHHmY=";
  };
  idrisLibraries = [ ];
};
in lspLibPkg.library { withSource = true; }
```

The above results in a derivation with the installed library results (with sourcecode).

A slightly more involved example of a fully packaged executable would be the [`idris2-lsp`](https://github.com/idris-community/idris2-lsp) which is an Idris2 language server that uses the `LSP-lib` found above.
```nix
{ callPackage, fetchFromGitHub, idris2Packages }:

# Assuming the previous example lives in `lsp-lib.nix`:
let lspLib = callPackage ./lsp-lib.nix { };
    inherit (idris2Packages) idris2Api;
    lspPkg = idris2Packages.buildIdris {
      ipkgName = "idris2-lsp";
      src = fetchFromGitHub {
         owner = "idris-community";
         repo = "idris2-lsp";
         rev = "main";
         hash = "sha256-vQTzEltkx7uelDtXOHc6QRWZ4cSlhhm5ziOqWA+aujk=";
      };
      idrisLibraries = [idris2Api lspLib];
    };
in lspPkg.executable
```

The above uses the default value of `withSource = false` for the `idris2Api` but could be modified to include that library's source by passing `(idris2Api { withSource = true; })` to `idrisLibraries` instead. `idris2Api` in the above derivation comes built in with `idris2Packages`. This library exposes many of the otherwise internal APIs of the Idris2 compiler.
