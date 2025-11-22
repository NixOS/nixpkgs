{
  lib,
  stdenv,
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  testers,
  makeWrapper,
  python3,
}:

buildGoModule (finalAttrs: {
  pname = "kluctl";
  version = "2.27.0";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m/bfZb+sp0gqxfMdBr/gAOxfYHdrPwKRcJAqprkAkQE=";
  };

  subPackages = [ "cmd" ];

  vendorHash = "sha256-TKMMMZ+8bv5kKgrHIp3CXmt4tpi5VejPpXv/oiX4M3c=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  # Depends on docker
  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      mv $out/bin/{cmd,kluctl}
      wrapProgram $out/bin/kluctl \
        --set KLUCTL_USE_SYSTEM_PYTHON 1 \
        --prefix PATH : '${lib.makeBinPath [ python3 ]}'
      installShellCompletion --cmd kluctl \
        --bash <(${emulator} $out/bin/kluctl completion bash) \
        --fish <(${emulator} $out/bin/kluctl completion fish) \
        --zsh  <(${emulator} $out/bin/kluctl completion zsh)
    '';

  meta = {
    description = "Missing glue to put together large Kubernetes deployments";
    mainProgram = "kluctl";
    homepage = "https://kluctl.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sikmir
      netthier
    ];
  };
})
