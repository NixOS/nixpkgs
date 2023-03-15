{ lib, buildDunePackage, fetchFromGitLab, ocaml
, fmt, lwt_ppx, menhir, ocf_ppx, ppx_blob, xtmpl_ppx
, dune-build-info, dune-site, higlo, logs, lwt, ocf, ptime, uri, uutf, xtmpl
}:

if lib.versionAtLeast ocaml.version "4.13"
then throw "stog is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "stog";
  version = "0.20.0";
  duneVersion = "3";
  minimalOCamlVersion = "4.12";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "stog";
    rev = version;
    sha256 = "sha256:0krj5w4y05bcfx7hk9blmap8avl31gp7yi01lpqzs6ync23mvm0x";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [ fmt lwt_ppx ocf_ppx ppx_blob xtmpl_ppx ];
  propagatedBuildInputs = [
    dune-build-info
    dune-site
    higlo
    logs
    lwt
    ocf
    ppx_blob
    ptime
    uri
    uutf
    xtmpl
  ];

  meta = with lib; {
    description = "XML documents and web site compiler";
    homepage = "https://www.good-eris.net/stog";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ regnat ];
  };
}
