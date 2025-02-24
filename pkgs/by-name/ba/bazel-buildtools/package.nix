{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bazel-buildtools";
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "v${version}";
    hash = "sha256-m1z3i1rddwXZK5VF4qwhaMCS5U3FZ5SawJz/IgdRgdU=";
  };

  vendorHash = "sha256-sYZ7ogQY0dWOwJMvLljOjaKeYGYdLrF5AnetregdlYY=";

  preBuild = ''
    rm -r warn/docs
  '';

  proxyVendor = true;

  doCheck = false;

  excludedPackages = [ "generatetables" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.buildVersion=${version}"
    "-X main.buildScmRevision=${src.rev}"
  ];

  meta = with lib; {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps";
    homepage = "https://github.com/bazelbuild/buildtools";
    changelog = "https://github.com/bazelbuild/buildtools/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers =
      with maintainers;
      [
        elasticdog
        uri-canva
      ]
      ++ lib.teams.bazel.members;
  };
}
