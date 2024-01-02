{ lib, buildDunePackage, fetchFromGitLab, fetchpatch, ocaml
, fmt, lwt_ppx, menhir, ocf_ppx, ppx_blob, xtmpl_ppx
, dune-build-info, dune-site, higlo, logs, lwt, ocf, ptime, uri, uutf, xtmpl
}:

if lib.versionAtLeast ocaml.version "4.13"
then throw "stog is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "stog";
  version = "0.20.0";
  minimalOCamlVersion = "4.12";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "stog";
    rev = version;
    sha256 = "sha256:0krj5w4y05bcfx7hk9blmap8avl31gp7yi01lpqzs6ync23mvm0x";
  };

  # Compatibility with higlo 0.9
  patches = fetchpatch {
    url = "https://framagit.org/zoggy/stog/-/commit/ea0546ab4cda8cc5c4c820ebaf2e3dfddc2ab101.patch";
    hash = "sha256-86GRHF9OjfcalGfA0Om2wXH99j4THCs9a4+o5ghuiJc=";
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
