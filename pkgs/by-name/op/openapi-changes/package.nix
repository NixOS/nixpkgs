{ lib
, buildGoModule
, fetchFromGitHub
, git
, makeWrapper
}:

buildGoModule rec {
  pname = "openapi-changes";
  version = "0.0.67";

  src = fetchFromGitHub {
    owner = "pb33f";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SNH11z/0DeaYfGwBKW3iIeCVdlpcoZ1elIlgl+quWIY=";
  };

  # this test requires the `.git` of the project to be present
  patchPhase = ''
    rm git/read_local_test.go
  '';

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/openapi-changes --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  vendorHash = "sha256-VtwIAP2+FZ6Vpexcb9O68WfJdsTMrJn5bDjkxDe69e4=";

  meta = with lib; {
    description = "World's sexiest OpenAPI breaking changes detector";
    homepage = "https://pb33f.io/openapi-changes/";
    changelog = "https://github.com/pb33f/openapi-changes/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mguentner ];
  };
}
