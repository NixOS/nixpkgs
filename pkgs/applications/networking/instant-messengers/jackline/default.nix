{ stdenv, fetchFromGitHub, ocamlPackages }:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.02.2";

stdenv.mkDerivation rec {
  version = "2017-12-24";
  name = "jackline-${version}";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "8678e8a1a06e641218a31ae25150040202f89289";
    sha256 = "05z9kvd7gwr59ic7hnmbayhwyyqd41xxz01cvdlcgplk3z7zlwg5";
  };

  patches = [ ./tls-0.9.0.patch ];

  buildInputs = with ocamlPackages; [
                  ocaml ocamlbuild findlib topkg ppx_sexp_conv
                  erm_xmpp_0_3 tls nocrypto x509 ocaml_lwt otr astring
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
