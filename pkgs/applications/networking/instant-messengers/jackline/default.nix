{ stdenv, fetchFromGitHub, ocamlPackages }:

assert stdenv.lib.versionAtLeast ocamlPackages.ocaml.version "4.07";

stdenv.mkDerivation {
  pname = "jackline";
  version = "unstable-2020-04-24";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "885b97b90d565f5f7c2b5f66f5edf14a82251b87";
    sha256 = "1mdn413ya2g0a1mrdbh1b65gnygrxb08k99z5lmidhh34kd1llsj";
  };

  buildInputs = with ocamlPackages; [
                  ocaml ocamlbuild findlib topkg ppx_sexp_conv ppx_deriving
                  erm_xmpp tls mirage-crypto mirage-crypto-pk x509 domain-name
                  ocaml_lwt otr astring ptime notty sexplib hex uutf
                  dns-client base64
                ];

  buildPhase = "${ocamlPackages.topkg.run} build --pinned true";

  inherit (ocamlPackages.topkg) installPhase;

  meta = with stdenv.lib; {
    broken = true;
    homepage = "https://github.com/hannesm/jackline";
    description = "minimalistic secure XMPP client in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
