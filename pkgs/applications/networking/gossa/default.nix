{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "gossa";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "pldubouilh";
    repo = "gossa";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-vonhVxXbYI/5Gl9ZwI8+a3YXSjoqLVic1twykiy+e34=";
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
    description = "A fast and simple multimedia fileserver";
    license = licenses.mit;
    maintainers = with maintainers; [ dsymbol ];
    mainProgram = "gossa";
  };
}
