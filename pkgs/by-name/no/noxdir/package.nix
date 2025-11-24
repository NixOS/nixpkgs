{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "noxdir";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "crumbyte";
    repo = "noxdir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sy94J+97fxg0t/GTSLzJQMDcQtOCQeo8TCTT8G4p6wY=";
  };

  vendorHash = "sha256-uRJP21bJ8NlJ0qOG81Gax9LJ+HdPfxLKj1Jjzbweync=";

  checkPhase = ''
    runHook preCheck
    go test -v -buildvcs -race ./...
    runHook postCheck
  '';

  meta = {
    description = "Terminal utility for visualizing file system usage";
    homepage = "https://github.com/crumbyte/noxdir";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ruiiiijiiiiang ];
    mainProgram = "noxdir";
  };
})
