{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  bazel-watcher,
  stdenv,
}:

buildGoModule rec {
  pname = "bazel-watcher";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    hash = "sha256-zbZhV1IjFW4USdj3MGdyfPabfCPUmAAaGBaguXqmcnY=";
  };

  vendorHash = "sha256-u1Zg/M9DSkwscy49qtPQygk1gyxKaPbhlFDYNtBQ9NY=";

  # The dependency github.com/fsnotify/fsevents requires CGO
  env.CGO_ENABLED = if stdenv.hostPlatform.isDarwin then "1" else "0";
  ldflags = [
    "-s"
    "-X main.Version=${version}"
  ];

  subPackages = [ "cmd/ibazel" ];

  passthru = {
    tests.version = testers.testVersion {
      package = bazel-watcher;
      command = "ibazel version";
    };
  };

  meta = {
    homepage = "https://github.com/bazelbuild/bazel-watcher";
    description = "Tools for building Bazel targets when source files change";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
    mainProgram = "ibazel";
    platforms = lib.platforms.all;
  };
}
