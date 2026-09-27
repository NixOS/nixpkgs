{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "bazel-buildtools";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SX/QeVsAn3yqovmjAo6NDFyfetNpRxb/C72zqWwCbaE=";
  };

  vendorHash = "sha256-bUvWtQ0DCdAQRETyPJ6gp4qlaPowlpO5l3GHFaEcH94=";

  preBuild = ''
    rm -r warn/docs
  '';

  proxyVendor = true;

  doCheck = false;

  excludedPackages = [ "generatetables" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.buildVersion=${finalAttrs.version}"
    "-X main.buildScmRevision=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps";
    homepage = "https://github.com/bazelbuild/buildtools";
    changelog = "https://github.com/bazelbuild/buildtools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.bazel ];
  };
})
