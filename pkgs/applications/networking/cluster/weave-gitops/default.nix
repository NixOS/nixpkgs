{ lib, fetchFromGitHub, buildGoModule, stdenv, installShellFiles }:

buildGoModule rec {
  pname = "weave-gitops";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d/MC+QJypLvURLRRp4U3oErf+MdyJ291Pa+gNPkV4xQ=";
  };

  ldflags = [ "-s" "-w" "-X github.com/weaveworks/weave-gitops/cmd/gitops/version.Version=${version}" ];

  vendorHash = "sha256-qwuV/c4lWjtmLp197EOScgZHMe4Wmnbj/Jy8x0n2VSo=";

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
