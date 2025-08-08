{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  testers,
  flytectl,
}:
buildGoModule (finalAttrs: {
  pname = "flytectl";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "flyteorg";
    repo = "flyte";
    tag = "flytectl/v${finalAttrs.version}";
    hash = "sha256-P44dt1f92YIqsLFaKcQ7wO6S9hz8cI6685ctbeRaYPw=";
  };

  vendorHash = "sha256-Zth+IRSBiTVFMjLVBQlbpewa0PUjw3EL9JH3GE9kAS0=";

  sourceRoot = "${finalAttrs.src.name}/flytectl";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/flyteorg/flyte/flytestdlib/version.Version=v${finalAttrs.version}"
    "-X github.com/flyteorg/flyte/flytestdlib/version.Build=${finalAttrs.src.tag}"
    "-X github.com/flyteorg/flyte/flytestdlib/version.BuildTime=1970-01-01"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Tests require network and file system access
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd flytectl \
      --bash <($out/bin/flytectl completion bash) \
      --fish <($out/bin/flytectl completion fish) \
      --zsh <($out/bin/flytectl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "flytectl version";
    version = "v${finalAttrs.src.version}";
  };

  meta = {
    description = "Command-line interface for Flyte, a cloud-native workflow orchestration platform";
    downloadPage = "https://github.com/flyteorg/flyte";
    homepage = "https://flyte.org/";
    changelog = "https://github.com/flyteorg/flyte/releases/tag/flytectl%2Fv${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mcuste ];
    mainProgram = "flytectl";
    platforms = lib.platforms.unix;
  };
})
