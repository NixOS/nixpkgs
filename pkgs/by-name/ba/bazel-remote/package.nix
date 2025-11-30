{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = "bazel-remote";
    rev = "v${version}";
    hash = "sha256-9vPaTm/HTJ3ftlFg+AkcwXX7xyhmGTgKL3PXhtUHRDk=";
  };

  vendorHash = "sha256-uh8ST1AQ8OsFMfXly23TMMcheNmhb1MknmPMjB76GIQ=";

  subPackages = [ "." ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.gitCommit=${version}"
  ];

  meta = {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "Remote HTTP/1.1 cache for Bazel";
    mainProgram = "bazel-remote";
    changelog = "https://github.com/buchgr/bazel-remote/releases/tag/v${version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.bazel ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
