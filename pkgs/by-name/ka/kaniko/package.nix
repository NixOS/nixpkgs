{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  testers,
  kaniko,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kaniko";
  version = "1.25.4";

  src = fetchFromGitHub {
    owner = "chainguard-dev";
    repo = "kaniko";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3wSiDFmcXk3gWbll4uSdvg6/TEP/JFIHX7Av4ATJO5s=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/chainguard-dev/kaniko/pkg/version.version=${finalAttrs.version}"
  ];

  excludedPackages = [ "hack/release_notes" ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false; # requires docker, container-diff (unpackaged yet)

  postInstall =
    let
      inherit (finalAttrs.meta) mainProgram;
    in
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash fish zsh; do
        $out/bin/${mainProgram} completion $shell > ${mainProgram}.$shell
        installShellCompletion ${mainProgram}.$shell
      done
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "version";

  meta = {
    description = "Tool to build container images from a Dockerfile, inside a container or Kubernetes cluster";
    homepage = "https://github.com/chainguard-dev/kaniko";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jk
      qjoly
    ];
    mainProgram = "executor";
  };
})
