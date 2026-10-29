{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "bazel-buildtools";
  version = "8.5.1";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ykfdajj9KpP9+j0uePYCRf7TDpb1GbGAiR6bI++jslg=";
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
    "-X main.buildVersion=${finalAttrs.version}"
    "-X main.buildScmRevision=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps";
    homepage = "https://github.com/bazelbuild/buildtools";
    changelog = "https://github.com/bazelbuild/buildtools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      elasticdog
    ];
    teams = [ lib.teams.bazel ];
  };
})
