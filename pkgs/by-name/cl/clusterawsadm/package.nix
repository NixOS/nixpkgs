{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "clusterawsadm";
  version = "2.13.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cluster-api-provider-aws";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-tPVYFKVZ5zyCJWOx8XSULSog61tkfi1Hbvg8Ry1dtEo=";
  };

  vendorHash = "sha256-rJ9Le4v4Q4Z6yBYfcVUZl3OqIeIkR/9pjzvp/jyAIF8=";

  ldflags = [
    "-s -w"
    "-X 'sigs.k8s.io/cluster-api-provider-aws/v2/version.gitMajor=${lib.versions.major finalAttrs.version}'"
    "-X 'sigs.k8s.io/cluster-api-provider-aws/v2/version.gitMinor=${lib.versions.minor finalAttrs.version}'"
    "-X 'sigs.k8s.io/cluster-api-provider-aws/v2/version.gitVersion=${finalAttrs.version}'"
  ];

  subPackages = [ "cmd/clusterawsadm" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";

  meta = {
    description = "CLI tool for managing AWS clusters with Cluster API";
    license = lib.licenses.asl20;
    homepage = "https://github.com/kubernetes-sigs/cluster-api-provider-aws";
    changelog = "https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/tag/v${finalAttrs.version}";
    mainProgram = "clusterawsadm";
    maintainers = with lib.maintainers; [ wcarlsen ];
  };
})
