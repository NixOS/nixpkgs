{stdenv, fetchFromGitHub, ocamlPackages, opam}:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.02.2";

stdenv.mkDerivation rec {
  version = "2017-05-21";
  name = "jackline-${version}";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "0a1e4ea23245633fe23edf09b2309659a1bc3649";
    sha256 = "1wnmwsp3a5nh3qs4h9grrdsvv0i3p419cfmhrrql3lj2x3ngdw82";
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
