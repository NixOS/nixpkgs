{ stdenv, fetchFromGitHub, ocaml, findlib, ocf, ptime,
  uutf, uri, ppx_blob, xtmpl, ocaml_lwt, higlo, camlp4, omd
}:

stdenv.mkDerivation rec {
  name = "stog-${version}";
  version = "0.17.0";
  src = fetchFromGitHub {
    owner = "zoggy";
    repo = "stog";
    rev = "release-${version}";
    sha256 = "06fnl3im0rycn05w39adfmm7w4s8l3jrj43h8f8h3b56grh21x0d";
  };

  buildInputs = [ ocaml camlp4 uutf ];
  propagatedBuildInputs = [ findlib omd ppx_blob ocf ptime uri xtmpl ocaml_lwt higlo ];

  createFindlibDestdir = true;

  patches = [ ./install.patch ];

  meta = with stdenv.lib; {
    description = "XML documents and web site compiler";
    homepage = https://zoggy.github.io/stog/;
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ regnat ];
  };
}


