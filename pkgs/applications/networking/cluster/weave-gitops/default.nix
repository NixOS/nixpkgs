{ lib, fetchFromGitHub, buildGoModule, stdenv, installShellFiles }:

buildGoModule rec {
  pname = "weave-gitops";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-chL88vWUMN4kcuh8g2ckWOqYAs9JwE0vnm69zLd5KIM=";
  };

  ldflags = [ "-s" "-w" "-X github.com/weaveworks/weave-gitops/cmd/gitops/version.Version=${version}" ];

  vendorHash = "sha256-EV8MDHiQBmp/mEB+ug/yALPhcqytp0W8V6IPP+nt9DA=";

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
