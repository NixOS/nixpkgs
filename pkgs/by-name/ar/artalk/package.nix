{
  lib,
  buildGoModule,
  fetchFromGitHub,
  artalk,
  fetchurl,
  installShellFiles,
  versionCheckHook,
  stdenv,
  testers,
  nixosTests,
}:
buildGoModule rec {
  pname = "artalk";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "ArtalkJS";
    repo = "artalk";
    rev = "refs/tags/v${version}";
    hash = "sha256-gzagE3muNpX/dwF45p11JAN9ElsGXNFQ3fCvF1QhvdU=";
  };
  web = fetchurl {
    url = "https://github.com/${src.owner}/${src.repo}/releases/download/v${version}/artalk_ui.tar.gz";
    hash = "sha256-ckKC4lErKVdJuJ+pGysmMR96a9LkrCYnWB4j6VPP8OY=";
  };

  vendorHash = "sha256-oAqYQzOUjly97H5L5PQ9I2SO2KqiUVxdJA+eoPrHD6Q=";

  ldflags = [
    "-s"
    "-w"
  ];

  preBuild = ''
    tar -xzf ${web}
    cp -r ./artalk_ui/* ./public
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd artalk \
      --bash <($out/bin/artalk completion bash) \
      --fish <($out/bin/artalk completion fish) \
      --zsh <($out/bin/artalk completion zsh)
  '';

  doInstallCheck = true;

  versionCheckProgramArg = "-v";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.tests = {
    inherit (nixosTests) artalk;
  };

  meta = {
    description = "Self-hosted comment system";
    homepage = "https://github.com/ArtalkJS/Artalk";
    changelog = "https://github.com/ArtalkJS/Artalk/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "artalk";
  };
}
