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
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    hash = "sha256-b99Fx9OY9SKYp56hQd39kmVQI5NvYnxKyIsqIxkQ2tE=";
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

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel-watcher";
    description = "Tools for building Bazel targets when source files change";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "ibazel";
    platforms = platforms.all;
  };
}
