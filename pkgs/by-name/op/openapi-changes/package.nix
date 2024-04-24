{ lib
, buildGoModule
, fetchFromGitHub
, git
, makeWrapper
}:

buildGoModule rec {
  pname = "openapi-changes";
  version = "0.0.61";

  src = fetchFromGitHub {
    owner = "pb33f";
    repo = pname;
    # github reports `the given path has multiple possibilities` for the tagged release
    # rev = "v${version}";
    rev = "f0bccc1fcf42ea6a97a81acc3283dbe14a3ebb51";
    hash = "sha256-D0jUXCxlf1aF0uc/P9Lgu9Va4Es3CQcko9BzGg1pCq8=";
  };

  # this test requires the `.git` of the project to be present
  patchPhase = ''
    rm git/read_local_test.go
  '';

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/openapi-changes --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  vendorHash = "sha256-gaBVwrSaIwe1eh8voq928cxM/d0urVUF0OUwWZb2fR8=";

  meta = with lib; {
    description = "The world's sexiest OpenAPI breaking changes detector";
    homepage = "https://pb33f.io/openapi-changes/";
    changelog = "https://github.com/pb33f/openapi-changes/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mguentner ];
  };
}
