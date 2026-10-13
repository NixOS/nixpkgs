{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "bazel-remote";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = "bazel-remote";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mlPxPtIhRQb59gb7M5F1p9Qkx1sNvuykNMXCCQeN65U=";
  };

  vendorHash = "sha256-PDDD46nYNMv8+sam/jOTHTHDjjrR0z2ckiXKlmoQpSU=";

  subPackages = [ "." ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.gitCommit=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "Remote HTTP/1.1 cache for Bazel";
    mainProgram = "bazel-remote";
    changelog = "https://github.com/buchgr/bazel-remote/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.bazel ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
