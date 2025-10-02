{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkgsBuildBuild,
}:

buildGoModule rec {
  pname = "argo-workflows";
  version = "3.6.10";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    tag = "v${version}";
    hash = "sha256-TM/eK8biMxKV4SFJ1Lys+NPPeaHVjbBo83k2RH1Xi40=";
  };

  vendorHash = "sha256-Y/2+ykzcJdA5uwP1v9Z1wZtF3hBV2x7XZc7+FhPJP64=";

  doCheck = false;

  subPackages = [
    "cmd/argo"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/argoproj/argo-workflows/v3.buildDate=unknown"
    "-X github.com/argoproj/argo-workflows/v3.gitCommit=${src.rev}"
    "-X github.com/argoproj/argo-workflows/v3.gitTag=${src.rev}"
    "-X github.com/argoproj/argo-workflows/v3.gitTreeState=clean"
    "-X github.com/argoproj/argo-workflows/v3.version=${version}"
  ];

  postInstall = ''
    for shell in bash zsh; do
      ${
        if (stdenv.buildPlatform == stdenv.hostPlatform) then
          "$out/bin/argo"
        else
          "${pkgsBuildBuild.argo}/bin/argo"
      } completion $shell > argo.$shell
      installShellCompletion argo.$shell
    done
  '';

  meta = {
    description = "Container native workflow engine for Kubernetes";
    mainProgram = "argo";
    homepage = "https://github.com/argoproj/argo";
    changelog = "https://github.com/argoproj/argo-workflows/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ groodt ];
    platforms = lib.platforms.unix;
  };
}
