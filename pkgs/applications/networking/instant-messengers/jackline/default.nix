{stdenv, fetchFromGitHub, ocamlPackages, opam}:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.02.2";

stdenv.mkDerivation rec {
  version = "2017-05-24";
  name = "jackline-${version}";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "49a326d5696aa24f3ac18534c8860e03d0d58548";
    sha256 = "0p741mzq4kkqyly8njga1f5dxdnfz31wy2lpvs5542pq0iwvdj7k";
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
