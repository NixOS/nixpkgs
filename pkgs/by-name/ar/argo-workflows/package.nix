{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkgsBuildBuild,
}:

buildGoModule (finalAttrs: {
  pname = "argo-workflows";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-workflows";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UmkUFuYFeuyqgdf/ByZkkulkVRregp53bvcyyEKgZQo=";
  };

  vendorHash = "sha256-UTBM1zd+HrC5bUadn0VSsO52HhqdPGzZwipQv7WOrNU=";

  doCheck = false;

  subPackages = [
    "cmd/argo"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  preBuild = ''
    mkdir -p ui/dist/app
    echo "Built without static files" > ui/dist/app/index.html
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/argoproj/argo-workflows/v4.buildDate=unknown"
    "-X github.com/argoproj/argo-workflows/v4.gitCommit=${finalAttrs.src.rev}"
    "-X github.com/argoproj/argo-workflows/v4.gitTag=${finalAttrs.src.rev}"
    "-X github.com/argoproj/argo-workflows/v4.gitTreeState=clean"
    "-X github.com/argoproj/argo-workflows/v4.version=${finalAttrs.version}"
  ];

  postInstall = ''
    for shell in bash zsh fish; do
      ${
        if (stdenv.buildPlatform == stdenv.hostPlatform) then
          "$out/bin/argo"
        else
          "${pkgsBuildBuild.argo-workflows}/bin/argo"
      } completion $shell > argo.$shell
      installShellCompletion argo.$shell
    done
  '';

  meta = {
    description = "Container native workflow engine for Kubernetes";
    mainProgram = "argo";
    homepage = "https://github.com/argoproj/argo-workflows";
    changelog = "https://github.com/argoproj/argo-workflows/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      groodt
      joibel
    ];
    platforms = lib.platforms.unix;
  };
})
