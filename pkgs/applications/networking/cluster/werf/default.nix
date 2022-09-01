{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, btrfs-progs
, glibc
, testers
, werf
}:

buildGoModule rec {
  pname = "werf";
  version = "1.2.166";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    rev = "v${version}";
    sha256 = "sha256-8LBGdjcnZTejH+lRo0im+czJJHOfhpmEB4DXM/qugYs=";
  };

  vendorSha256 = "sha256-E5yDk48O7zze8QTeLQ999QmB8XLkpKNZ8JQ2wVRMGCU=";

  proxyVendor = true;

  subPackages = [ "cmd/werf" ];

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isLinux [ btrfs-progs glibc.static ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/werf/werf/pkg/werf.Version=${src.rev}"
  ] ++ lib.optionals stdenv.isLinux [
    "-extldflags=-static"
    "-linkmode external"
  ];

  tags = [
    "containers_image_openpgp"
    "dfrunmount"
    "dfssh"
  ] ++ lib.optionals stdenv.isLinux [
    "exclude_graphdriver_devicemapper"
    "netgo"
    "no_devmapper"
    "osusergo"
    "static_build"
  ];

  # There are no tests for cmd/werf.
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd werf \
      --bash <($out/bin/werf completion --shell=bash) \
      --zsh <($out/bin/werf completion --shell=zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = werf;
    command = "werf version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "GitOps delivery tool";
    longDescription = ''
      The CLI tool gluing Git, Docker, Helm & Kubernetes with any CI system to
      implement CI/CD and Giterminism.
    '';
    homepage = "https://werf.io";
    changelog = "https://github.com/werf/werf/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
  };
}
