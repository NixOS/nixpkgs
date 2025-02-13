{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  git,
  makeWrapper,
}:

buildGo123Module rec {
  pname = "openapi-changes";
  version = "0.0.68";

  src = fetchFromGitHub {
    owner = "pb33f";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-v+THD4ZWnpeuxLfxaA4LUGdYV3X5rUKeCWq9HIub59Y=";
  };

  # this test requires the `.git` of the project to be present
  patchPhase = ''
    rm git/read_local_test.go
  '';

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/openapi-changes --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  vendorHash = "sha256-IiI+mSbJNEpM6rryGtAnGSOcY2RXnvqXTZmZ82L1HPc=";

  meta = with lib; {
    description = "World's sexiest OpenAPI breaking changes detector";
    homepage = "https://pb33f.io/openapi-changes/";
    changelog = "https://github.com/pb33f/openapi-changes/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mguentner ];
  };
}
