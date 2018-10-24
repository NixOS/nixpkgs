{ stdenv, fetchFromGitHub, ocamlPackages }:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.02.2";

stdenv.mkDerivation rec {
  version = "2018-05-11";
  name = "jackline-${version}";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "bc36b1c8b80fee6baba4f91011cd01b82a06e8eb";
    sha256 = "1xx2yx8a95m84sa1bkxi3rlx7pd39zkqwk3znj0zzz3cni6apfrz";
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
