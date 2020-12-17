# Coq {#sec-language-coq}

Coq libraries should be installed in `$(out)/lib/coq/${coq.coq-version}/user-contrib/`. Such directories are automatically added to the `$COQPATH` environment variable by the hook defined in the Coq derivation.

Some extensions (plugins) might require OCaml and sometimes other OCaml packages. The `coq.ocamlPackages` attribute can be used to depend on the same package set Coq was built against.

Coq libraries may be compatible with some specific versions of Coq only. The `compatibleCoqVersions` attribute is used to precisely select those versions of Coq that are compatible with this derivation.

Here is a simple package example. It is a pure Coq library, thus it depends on Coq. It builds on the Mathematical Components library, thus it also takes `mathcomp` as `buildInputs`. Its `Makefile` has been generated using `coq_makefile` so we only have to set the `$COQLIB` variable at install time.

```nix
{ stdenv, fetchFromGitHub, coq, mathcomp }:

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-multinomials-${version}";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "math-comp";
    repo = "multinomials";
    rev = version;
    sha256 = "1qmbxp1h81cy3imh627pznmng0kvv37k4hrwi2faa101s6bcx55m";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ mathcomp ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = {
    description = "A Coq/SSReflect Library for Monoidal Rings and Multinomials";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.cecill-b;
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" ];
  };
}
```
