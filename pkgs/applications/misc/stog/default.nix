{ lib, buildDunePackage, fetchFromGitLab, fetchpatch, ocaml
, fmt, lwt_ppx, menhir, ocf_ppx, ppx_blob, xtmpl_ppx
, conduit-lwt-unix, dune-build-info, dune-site, higlo, logs, lwt, ocf, ptime, uri, uutf, xtmpl
}:

if lib.versionOlder ocaml.version "5.0.0"
then throw "stog is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "stog";
  version = "1.0.0";
  minimalOCamlVersion = "4.12";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "stog";
    rev = version;
    sha256 = "sha256-hMb6D6VSq2o2NjycwxZt3mZKy1FR+3afEwbOmTc991g=";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [ fmt lwt_ppx ocf_ppx ppx_blob xtmpl_ppx ];
  propagatedBuildInputs = [
    conduit-lwt-unix
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
    changelog = "https://framagit.org/zoggy/stog/-/raw/${src.rev}/Changes";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ regnat ];
    mainProgram = "stog";
  };
}
