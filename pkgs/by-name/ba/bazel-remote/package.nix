{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = "bazel-remote";
    rev = "v${version}";
    hash = "sha256-qsNIfl3Y+2MaflTCL+uKV1T6tMe1AFIt+fOz/bB3EEQ=";
  };

  vendorHash = "sha256-cZe1jFJZnZy960lyV3nMO0+ZotwjMn1tSyeFj05tZao=";

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
