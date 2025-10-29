{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "gossa";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "pldubouilh";
    repo = "gossa";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-FGlUj0BJ8KeCfvdN9+NG4rqtaUIxgpqQ+09Ie1/TpAQ=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require a socket connection to be created.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pldubouilh/gossa";
    description = "Fast and simple multimedia fileserver";
    license = licenses.mit;
    maintainers = with maintainers; [ dsymbol ];
    mainProgram = "gossa";
  };
}
