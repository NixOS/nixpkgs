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
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "kubelogin";
    rev = "v${version}";
    sha256 = "sha256-pi2dzIf48mqD3S7QqaZZ5sgcgPRtQZ10KpfojLVYCZA=";
  };

  vendorHash = "sha256-tuqWg7z9YJygEW3XwBXDwXHUNwaJeTAxRS1xv6bQpj4=";

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
