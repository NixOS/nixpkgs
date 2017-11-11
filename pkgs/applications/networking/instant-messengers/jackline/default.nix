{stdenv, fetchFromGitHub, ocamlPackages, opam}:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.02.2";

stdenv.mkDerivation rec {
  version = "2017-08-17";
  name = "jackline-${version}";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "26688f07c3edc3b83e7aa0b9136cd1e9dcb58ed5";
    sha256 = "0yspgjhp7zy9rzvwl4pxppf5wkpa07y0122s7n09kvr0fzsh6aqf";
  };

  buildInputs = with ocamlPackages; [
                  ocaml ocamlbuild findlib topkg ppx_sexp_conv
                  erm_xmpp_0_3 tls nocrypto x509 ocaml_lwt otr astring
                  ptime notty sexplib_p4 hex uutf opam
                ];

  buildPhase = with ocamlPackages;
    "ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib pkg/pkg.ml build --pinned true";

  installPhase = "opam-installer --prefix=$out --script | sh";

  meta = with stdenv.lib; {
    homepage = https://github.com/hannesm/jackline;
    description = "Terminal-based XMPP client in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
