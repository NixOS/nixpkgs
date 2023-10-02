{ lib, fetchFromGitHub, buildGoModule, stdenv, installShellFiles }:

buildGoModule rec {
  pname = "weave-gitops";
  version = "0.31.2";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bzYvyqLMdVdgp8C71mnykzB9HEIPDXQ+SpBOScKybJ8=";
  };

  ldflags = [ "-s" "-w" "-X github.com/weaveworks/weave-gitops/cmd/gitops/version.Version=${version}" ];

  vendorHash = "sha256-3woVoEh+bU8QOzOEk7hnxxVe0mlPozqUDuP0Rn/9J6k=";

  subPackages = [ "cmd/gitops" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gitops \
      --bash <($out/bin/gitops completion bash 2>/dev/null) \
      --fish <($out/bin/gitops completion fish 2>/dev/null) \
      --zsh <($out/bin/gitops completion zsh 2>/dev/null)
  '';

  meta = with lib; {
    homepage = "https://docs.gitops.weave.works";
    description = "Weave Gitops CLI";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nullx76 ];
    mainProgram = "gitops";
  };
}
