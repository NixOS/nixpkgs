{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  gitUpdater,
  makeWrapper,
}:

buildGoModule rec {
  pname = "openapi-changes";
  version = "0.0.75";

  src = fetchFromGitHub {
    owner = "pb33f";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/bUnCN+/Gs5RW3N5fl0/ucwMG4mrYPG0syYMMqIQzIQ=";
  };

  # this test requires the `.git` of the project to be present
  patchPhase = ''
    rm git/read_local_test.go
  '';

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/openapi-changes --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  vendorHash = "sha256-bcQAXPw4x+oXx3L0vypbqp96nYdcjQo6M3yOwFbIdpg=";

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "World's sexiest OpenAPI breaking changes detector";
    homepage = "https://pb33f.io/openapi-changes/";
    changelog = "https://github.com/pb33f/openapi-changes/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mguentner ];
  };
}
