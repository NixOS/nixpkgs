{stdenv, fetchFromGitHub, ocamlPackages, opam}:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.02.2";

stdenv.mkDerivation rec {
  version = "2016-11-18";
  name = "jackline-${version}";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "cab34acab004023911997ec9aee8b00a976af7e4";
    sha256 = "0h7wdsic4v6ys130w61zvxm5s2vc7y574hn7zby12rq88lhhrjh7";
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
