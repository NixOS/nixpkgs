{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = "bazel-remote";
    rev = "v${version}";
    hash = "sha256-TKfoQEUYsLDJL9sINoCOBeB7SgH5MyyuUIOAhRoZLfU=";
  };

  vendorHash = "sha256-bM545QqUXg8io6SNK4dtT+UL/MTvQW7pi+Mb3rb7R48=";

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
