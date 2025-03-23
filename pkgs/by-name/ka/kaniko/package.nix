{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  testers,
  kaniko,
}:

buildGoModule rec {
  pname = "kaniko";
  version = "1.23.2";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "kaniko";
    rev = "v${version}";
    hash = "sha256-8SLE9s+P6Xh4PzrvTwUtIAtkG9Gor/fGBwrqq/fz0UM=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/GoogleContainerTools/kaniko/pkg/version.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false; # requires docker, container-diff (unpackaged yet)

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      $out/bin/executor completion $shell > executor.$shell
      installShellCompletion executor.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = kaniko;
    version = version;
    command = "${kaniko}/bin/executor version";
  };

  meta = {
    description = "Tool to build container images from a Dockerfile, inside a container or Kubernetes cluster";
    homepage = "https://github.com/GoogleContainerTools/kaniko";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jk
      qjoly
    ];
    mainProgram = "executor";
  };
}
