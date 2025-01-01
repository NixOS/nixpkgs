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
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VmCJoyr42tbQhe8o54D/t9+Gfz40Oe6NzqqJWknNP70=";
  };

  vendorHash = "sha256-8L5OzEJvHBOHPkZyIitIW8hBzmOytTDUUTGlAmY5zBg=";

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
