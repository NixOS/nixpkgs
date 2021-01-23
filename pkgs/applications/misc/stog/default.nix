{ lib, stdenv, fetchFromGitLab, ocaml, findlib, ocf, ptime,
  uutf, uri, ppx_blob, xtmpl, ocaml_lwt, higlo, omd
}:

stdenv.mkDerivation rec {
  pname = "stog";
  version = "0.18.0";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "stog";
    rev = version;
    sha256 = "154gl3ljxqlw8wz1vmsyv8180igrl5bjq0wir7ybrnzq2cdflkv0";
  };

  buildInputs = [ ocaml uutf ];
  propagatedBuildInputs = [ findlib omd ppx_blob ocf ptime uri xtmpl ocaml_lwt higlo ];

  createFindlibDestdir = true;

  patches = [ ./install.patch ./uri.patch ];

  meta = with lib; {
    description = "XML documents and web site compiler";
    homepage = "https://www.good-eris.net/stog";
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ regnat ];
  };
}


