{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = "bazel-remote";
    rev = "v${version}";
    hash = "sha256-PjhLybiZoq7Uies2bWdlLKAbKcG3+AQZ55Qp706u7hc=";
  };

  vendorHash = "sha256-okXGqPN/Do7Ht3zW8jVWo+8YquUEqNhirr9pPqMelmk=";

  subPackages = [ "." ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.gitCommit=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "Remote HTTP/1.1 cache for Bazel";
    mainProgram = "bazel-remote";
    changelog = "https://github.com/buchgr/bazel-remote/releases/tag/v${version}";
    license = licenses.asl20;
    teams = [ lib.teams.bazel ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
