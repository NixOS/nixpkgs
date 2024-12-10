{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  name = "regal";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-bQKVebpDqmwTAbocL10WrvA4HeVjDaGcbX090cX7HPw=";
  };

  vendorHash = "sha256-EaOMIfkaYPXmsqw/Oi3caKjarR5ijwcoK+EXwGfSUqE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/styrainc/regal/pkg/version.Version=${version}"
    "-X github.com/styrainc/regal/pkg/version.Commit=${version}"
  ];

  meta = with lib; {
    description = "Linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/StyraInc/regal";
    changelog = "https://github.com/StyraInc/regal/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ rinx ];
  };
}
