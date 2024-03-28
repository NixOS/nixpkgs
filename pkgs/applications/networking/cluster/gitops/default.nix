{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, gitops }:

buildGoModule rec {
  pname = "gitops";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "weave-gitops";
    rev = "727513969553bfcc603e1c0ae1a75d79e4132b58";
    sha256 = "sha256-OiNSo17S2KSnuLrPPSPjMUCinPbYmEZoT/bZlS3isWQ=";
  };

  vendorSha256 = "sha256-p+ikGLqYwdC+/IAE9wbcq3w0xoTf5xlqrYmXx3f40+U=";

  subPackages = [ "cmd/gitops" ];

  ldflags =
    let
      package_url = "github.com/weaveworks/weave-gitops";
      # these are likely not necessary
      flux_version = "0.37.0";
      dev_bucket_container_image = "ghcr.io/weaveworks/gitops-bucket-server@sha256:9fa2a68032b9d67197a3d41a46b5029ffdf9a7bc415e4e7e9794faec8bc3b8e4";
      tier = "oss";
      helm_chart_version = "4.0.11";
    in
    [
      "-X ${package_url}/cmd/gitops/version.Branch=releases/v${version}"
      "-X ${package_url}/cmd/gitops/version.BuildTime=1970-01-01_00:00:00"
      "-X ${package_url}/cmd/gitops/version.GitCommit=${src.rev}"
      "-X ${package_url}/cmd/gitops/version.Version=v${version}"
      # these are likely not necessary
      "-X ${package_url}/pkg/version.FluxVersion=${flux_version}"
      "-X ${package_url}/pkg/run/watch.DevBucketContainerImage=${dev_bucket_container_image}"
      "-X ${package_url}/pkg/analytics.Tier=${tier}"
      "-X ${package_url}/core/server.Branch=releases/v${version}"
      "-X ${package_url}/core/server.Buildtime=1970-01-01_00:00:00"
      "-X ${package_url}/core/server.GitCommit=${src.rev}"
      "-X ${package_url}/core/server.Version=v${version}"
      "-X ${package_url}/cmd/gitops/beta/run.HelmChartVersion=${helm_chart_version}"
    ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd gitops \
      --bash <($out/bin/gitops completion bash --no-analytics) \
      --zsh <($out/bin/gitops completion zsh --no-analytics) \
      --fish <($out/bin/gitops completion fish --no-analytics)
  '';

  passthru.tests.version = testers.testVersion {
    package = gitops;
    command = "gitops version --no-analytics";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Weave GitOps OSS";
    homepage = "https://docs.gitops.weave.works/docs/intro";
    changelog = "https://github.com/weaveworks/weave-gitops/releases/tag/v${version}";
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
