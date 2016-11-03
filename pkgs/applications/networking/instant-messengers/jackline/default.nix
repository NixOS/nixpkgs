{stdenv, fetchFromGitHub, ocamlPackages}:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.02.2";

stdenv.mkDerivation rec {
  version = "2016-10-30";
  name = "jackline-${version}";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "8d829b03f2cdad6b13260ad293aeaa44075bd894";
    sha256 = "1xsngldyracfb15jxa9h5qnpaywv6bn8gkg0hzccycjz1nfskl17";
  };

  buildInputs = with ocamlPackages; [
                  ocaml ocamlbuild findlib topkg ppx_sexp_conv
                  erm_xmpp_0_3 tls nocrypto x509 ocaml_lwt otr astring
                  ptime notty sexplib_p4 hex uutf opam
                ];

  buildPhase = with ocamlPackages; ''
    ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib pkg/pkg.ml build \
      --pinned true
  '';

  installPhase = ''
    opam-installer --prefix=$out --script | sh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/hannesm/jackline;
    description = "Terminal-based XMPP client in pure OCaml.";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
