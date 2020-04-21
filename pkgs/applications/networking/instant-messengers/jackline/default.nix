{ stdenv, fetchFromGitHub, ocamlPackages }:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.07";

stdenv.mkDerivation {
  pname = "jackline";
  version = "unstable-2020-03-22";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "52f84525c74c43e8d03fb1e6ff025ccb2699e4aa";
    sha256 = "0wir573ah1w16xzdn9rfwk3569zq4ff5frp0ywq70va4gdlb679c";
  };

  buildInputs = with ocamlPackages; [
                  ocaml ocamlbuild findlib topkg ppx_sexp_conv ppx_deriving
                  erm_xmpp tls mirage-crypto mirage-crypto-pk x509 domain-name
                  ocaml_lwt otr astring ptime mtime notty sexplib hex uutf
                  dns-client base64
                ];

  buildPhase = "${ocamlPackages.topkg.run} build --pinned true";

  inherit (ocamlPackages.topkg) installPhase;

  meta = with stdenv.lib; {
    homepage = "https://github.com/hannesm/jackline";
    description = "minimalistic secure XMPP client in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
