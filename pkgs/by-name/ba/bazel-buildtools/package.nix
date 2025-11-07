{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bazel-buildtools";
  version = "8.2.1";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "v${version}";
    hash = "sha256-YkxEc+hcfOH2zzdHngoJmuCqGD4FWSkFd2cVqIrpHD4=";
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

  meta = {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps";
    homepage = "https://github.com/bazelbuild/buildtools";
    changelog = "https://github.com/bazelbuild/buildtools/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      elasticdog
      uri-canva
    ];
    teams = [ lib.teams.bazel ];
  };
}
