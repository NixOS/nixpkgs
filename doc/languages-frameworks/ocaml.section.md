# OCaml {#sec-language-ocaml}

## User guide {#sec-language-ocaml-user-guide}

OCaml libraries are available in attribute sets of the form `ocaml-ng.ocamlPackages_X_XX` where X is to be replaced with the desired compiler version. For example, ocamlgraph compiled with OCaml 4.12 can be found in `ocaml-ng.ocamlPackages_4_12.ocamlgraph`. The compiler itself is also located in this set, under the name `ocaml`.

If you don't care about the exact compiler version, `ocamlPackages` is a top-level alias pointing to a recent version of OCaml.

OCaml applications are usually available top-level, and not inside `ocamlPackages`. Notable exceptions are build tools that must be built with the same compiler version as the compiler you intend to use like `dune` or `ocaml-lsp`.

To open a shell able to build a typical OCaml project, put the dependencies in `buildInputs` and add `ocamlPackages.ocaml` and `ocamlPackages.findlib` to `nativeBuildInputs` at least.
For example:
```nix
let
 pkgs = import <nixpkgs> {};
 # choose the ocaml version you want to use
 ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_12;
in
pkgs.mkShell {
  # build tools
  nativeBuildInputs = with ocamlPackages; [ ocaml findlib dune_2 ocaml-lsp ];
  # dependencies
  buildInputs = with ocamlPackages; [ ocamlgraph ];
}
```

## Packaging guide {#sec-language-ocaml-packaging}

OCaml libraries should be installed in `$(out)/lib/ocaml/${ocaml.version}/site-lib/`. Such directories are automatically added to the `$OCAMLPATH` environment variable when building another package that depends on them or when opening a `nix-shell`.

Given that most of the OCaml ecosystem is now built with dune, nixpkgs includes a convenience build support function called `buildDunePackage` that will build an OCaml package using dune, OCaml and findlib and any additional dependencies provided as `buildInputs` or `propagatedBuildInputs`.

Here is a simple package example.

- It defines an (optional) attribute `minimalOCamlVersion` (see note below)
  that will be used to throw a descriptive evaluation error if building with
  an older OCaml is attempted.

- It uses the `fetchFromGitHub` fetcher to get its source.

- It also accept `duneVersion` parameter (valid value are `"1"`, `"2"`, and
  `"3"`). The recommended practice it to set only if you don't want the default
  value and/or it depends on something else like package version. You might see
  a not-supported argument `useDune2`. The behavior was `useDune2 = true;` =>
  `duneVersion = "2";` and `useDune2 = false;` => `duneVersion = "1";`. It was
  used at the time when dune3 didn't existed.

- It sets the optional `doCheck` attribute such that tests will be run with
  `dune runtest -p angstrom` after the build (`dune build -p angstrom`) is
  complete, but only if the Ocaml version is at at least `"4.05"`.

- It uses the package `ocaml-syntax-shims` as a build input, `alcotest` and
  `ppx_let` as check inputs (because they are needed to run the tests), and
  `bigstringaf` and `result` as propagated build inputs (thus they will also be
  available to libraries depending on this library).

- The library will be installed using the `angstrom.install` file that dune
  generates.

```nix
{ lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  ocaml-syntax-shims,
  alcotest,
  result,
  bigstringaf,
  ppx_let }:

buildDunePackage rec {
  pname = "angstrom";
  version = "0.15.0";

  minimalOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = pname;
    rev    = version;
    hash   = "sha256-MK8o+iPGANEhrrTc1Kz9LBilx2bDPQt7Pp5P2libucI=";
  };

  checkInputs = [ alcotest ppx_let ];
  buildInputs = [ ocaml-syntax-shims ];
  propagatedBuildInputs = [ bigstringaf result ];
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = {
    homepage = "https://github.com/inhabitedtype/angstrom";
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
```

Here is a second example, this time using a source archive generated with `dune-release`. It is a good idea to use this archive when it is available as it will usually contain substituted variables such as a `%%VERSION%%` field. This library does not depend on any other OCaml library and no tests are run after building it.

```nix
{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "wtf8";
  version = "1.0.2";

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    hash = "sha256-d5/3KUBAWRj8tntr4RkJ74KWW7wvn/B/m1nx0npnzyc=";
  };

  meta = {
    homepage = "https://github.com/flowtype/ocaml-wtf8";
    description = "WTF-8 is a superset of UTF-8 that allows unpaired surrogates";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eqyiel ];
  };
}
```

The build will automatically fail if two distinct versions of the same library
are added to `buildInputs` (which usually happens transitively because of
`propagatedBuildInputs`). Set `dontDetectOcamlConflicts` to true to disable this
behavior.
