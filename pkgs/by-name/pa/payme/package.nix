{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "payme";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "payme";
    rev = "v${version}";
    hash = "sha256-kHe+RbPN1WGZ5xL6jhkKs7dBXgHLyMhagoR3oClSjvE=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.gitRefName=${src.rev}"
  ];

  preBuild = ''
    ldflags+=" -X main.gitCommit=$(cat COMMIT)"
  '';

  meta = {
    description = "QR code generator (ASCII & PNG) for SEPA payments";
    mainProgram = "payme";
    homepage = "https://github.com/jovandeginste/payme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cimm ];
  };
}
