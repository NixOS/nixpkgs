{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "bazel-buildtools";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pnzvuerzKSxF++GeceGOzGgx0nQjAAKCj9fnjW1EIIE=";
  };

  vendorHash = "sha256-N8mmt5P+hL0WzxLrVwEywSh9BAMZj2s2WzwNoB4o4bU=";

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
