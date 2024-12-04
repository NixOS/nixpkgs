{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  testers,
  kubelogin,
}:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/qA/M0Z71j3h5zKDMUWsni9lgbrCcjYHpnhFPVRJ1qA=";
  };

  vendorHash = "sha256-qz51x1d8Uk3N5vrDMVgJxFIxXTMiDCPplI7SmJjZ3sI=";

  ldflags = [
    "-X main.gitTag=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/kubelogin completion bash >kubelogin.bash
    $out/bin/kubelogin completion fish >kubelogin.fish
    $out/bin/kubelogin completion zsh >kubelogin.zsh
    installShellCompletion kubelogin.{bash,fish,zsh}
  '';

  passthru.tests.version = testers.testVersion {
    package = kubelogin;
    version = "v${version}";
  };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Kubernetes credential plugin implementing Azure authentication";
    mainProgram = "kubelogin";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = [ ];
  };
}
