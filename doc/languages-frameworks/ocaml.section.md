# OCaml {#sec-language-ocaml}

OCaml libraries should be installed in `$(out)/lib/ocaml/${ocaml.version}/site-lib/`. Such directories are automatically added to the `$OCAMLPATH` environment variable when building another package that depends on them or when opening a `nix-shell`.

Given that most of the OCaml ecosystem is now built with dune, nixpkgs includes a convenience build support function called `buildDunePackage` that will build an OCaml package using dune, OCaml and findlib and any additional dependencies provided as `buildInputs` or `propagatedBuildInputs`.

Here is a simple package example. It defines an (optional) attribute `minimumOCamlVersion` that will be used to throw a descriptive evaluation error if building with an older OCaml is attempted. It uses the `fetchFromGitHub` fetcher to get its source. It sets the `doCheck` (optional) attribute to `true` which means that tests will be run with `dune runtest -p angstrom` after the build (`dune build -p angstrom`) is complete. It uses `alcotest` as a build input (because it is needed to run the tests) and `bigstringaf` and `result` as propagated build inputs (thus they will also be available to libraries depending on this library). The library will be installed using the `angstrom.install` file that dune generates.

```nix
{ stdenv
, fetchFromGitHub
, buildDunePackage
, alcotest
, result
, bigstringaf
}:

buildDunePackage rec {
  pname = "angstrom";
  version = "0.10.0";

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = pname;
    rev    = version;
    sha256 = "0lh6024yf9ds0nh9i93r9m6p5psi8nvrqxl5x7jwl13zb0r9xfpw";
  };

  buildInputs = [ alcotest ];
  propagatedBuildInputs = [ bigstringaf result ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/inhabitedtype/angstrom";
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
```

Here is a second example, this time using a source archive generated with `dune-release`. It is a good idea to use this archive when it is available as it will usually contain substituted variables such as a `%%VERSION%%` field. This library does not depend on any other OCaml library and no tests are run after building it.

```nix
{ stdenv
, fetchurl
, buildDunePackage
}:

buildDunePackage rec {
  pname = "wtf8";
  version = "1.0.1";

  minimumOCamlVersion = "4.01";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "1msg3vycd3k8qqj61sc23qks541cxpb97vrnrvrhjnqxsqnh6ygq";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/flowtype/ocaml-wtf8";
    description = "WTF-8 is a superset of UTF-8 that allows unpaired surrogates.";
    license = licenses.mit;
    maintainers = [ maintainers.eqyiel ];
  };
}
```
