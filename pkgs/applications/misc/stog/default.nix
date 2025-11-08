{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  fmt,
  lwt_ppx,
  menhir,
  ocf_ppx,
  ppx_blob,
  xtmpl_ppx,
  dune-build-info,
  dune-site,
  higlo,
  logs,
  lwt,
  ocf,
  ptime,
  uri,
  uutf,
  xtmpl,
}:

buildDunePackage rec {
  pname = "stog";
  version = "1.1.0";
  minimalOCamlVersion = "4.13";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "stog";
    tag = version;
    hash = "sha256-seaVco5AoOxjEuw8zYsrA25vcyo1Un3eUJUU9FT57WU=";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [
    lwt_ppx
    ocf_ppx
    ppx_blob
    xtmpl_ppx
  ];
  propagatedBuildInputs = [
    dune-build-info
    dune-site
    fmt
    higlo
    logs
    lwt
    ocf
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
