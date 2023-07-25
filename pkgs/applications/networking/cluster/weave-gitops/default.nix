{ lib, fetchFromGitHub, buildGoModule, stdenv, installShellFiles }:

buildGoModule rec {
  pname = "weave-gitops";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sHk9ULh/792BEjPRcaeY3umx3pcLb41urrrouunm9nw=";
  };

  ldflags = [ "-s" "-w" "-X github.com/weaveworks/weave-gitops/cmd/gitops/version.Version=${version}" ];

  vendorSha256 = "sha256-Q9LjKgaFUx4txJlPcrG/YIbHV4hh5oWHVXIBDDgKYRg=";

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
