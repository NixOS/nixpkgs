{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gossa";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "pldubouilh";
    repo = "gossa";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-eMO9aoI+otGQcvBUJtxciQ7yhUidYizLrDjMVchH3qA=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  # Tests require a socket connection to be created.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pldubouilh/gossa";
    description = "A fast and simple multimedia fileserver";
    license = licenses.mit;
    maintainers = with maintainers; [ dsymbol ];
  };
}
