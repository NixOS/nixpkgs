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
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "kubelogin";
    rev = "v${version}";
    sha256 = "sha256-Vy3HRNBYP+q/DWVib47jolg4W2HgdAAqjcFghfpapSE=";
  };

  patches = [
    ./disable-nix-incompatible-test.patch
  ];

  vendorHash = "sha256-CWgvbN8NnroSVqfKF8UG6kXqVWrQ0TmKwri1f218K+M=";

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
