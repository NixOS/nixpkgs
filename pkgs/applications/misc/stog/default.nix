{ lib, buildDunePackage, fetchFromGitLab
, fmt, lwt_ppx, menhir, ocf_ppx, ppx_blob, xtmpl_ppx
, dune-build-info, dune-site, higlo, logs, lwt, ocf, ptime, uri, uutf, xtmpl
}:

buildDunePackage rec {
  pname = "stog";
  version = "1.0.0";
  minimalOCamlVersion = "4.13";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "stog";
    rev = version;
    hash = "sha256-hMb6D6VSq2o2NjycwxZt3mZKy1FR+3afEwbOmTc991g=";
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
