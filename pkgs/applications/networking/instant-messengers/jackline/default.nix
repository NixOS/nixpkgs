{ stdenv, fetchFromGitHub, ocamlPackages }:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.02.2";

stdenv.mkDerivation {
  pname = "jackline";
  version = "2019-08-08";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "b934594010a563ded9c0f436e3fab8f1cae29856";
    sha256 = "076h03jd970xlii90ax6kvgyq67g81gs30yvdzps366n7zzy3yfc";
  };

  buildInputs = with ocamlPackages; [
                  ocaml ocamlbuild findlib topkg ppx_sexp_conv
                  erm_xmpp tls nocrypto x509 ocaml_lwt otr astring
                  ptime notty sexplib hex uutf
                ];

  buildPhase = "${ocamlPackages.topkg.run} build --pinned true";

  inherit (ocamlPackages.topkg) installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/hannesm/jackline;
    description = "Terminal-based XMPP client in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
