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

- `useDune2 = true` ensures that Dune version 2 is used for the
  build (this is the default; set to `false` to use Dune version 1).

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
  useDune2 = true;

  minimalOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = pname;
    rev    = version;
    sha256 = "1hmrkdcdlkwy7rxhngf3cv3sa61cznnd9p5lmqhx20664gx2ibrh";
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
```

Here is a second example, this time using a source archive generated with `dune-release`. It is a good idea to use this archive when it is available as it will usually contain substituted variables such as a `%%VERSION%%` field. This library does not depend on any other OCaml library and no tests are run after building it.

```nix
{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "wtf8";
  version = "1.0.2";

  useDune2 = true;

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "09ygcxxd5warkdzz17rgpidrd0pg14cy2svvnvy1hna080lzg7vp";
  };

  meta = with lib; {
    homepage = "https://github.com/flowtype/ocaml-wtf8";
    description = "WTF-8 is a superset of UTF-8 that allows unpaired surrogates.";
    license = licenses.mit;
    maintainers = [ maintainers.eqyiel ];
  };
}
```

Note about `minimalOCamlVersion`.  A deprecated version of this argument was
spelled `minimumOCamlVersion`; setting the old attribute wrongly modifies the
derivation hash and is therefore inappropriate. As a technical dept, currently
packaged libraries may still use the old spelling: maintainers are invited to
fix this when updating packages. Massive renaming is strongly discouraged as it
would be challenging to review, difficult to test, and will cause unnecessary
rebuild.
