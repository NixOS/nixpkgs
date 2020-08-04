{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubespy";
  version = "0.5.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "pulumi";
    repo = "kubespy";
    sha256 = "1p0qmn6458pa9la6zkvyrkgs2rhzfwsk9m3rk5fkmcfbh7b031r8";
  };

  vendorSha256 = "0q85is01cbgxflnqdvxc9w5iqdizgvsc44h8z21j712bm2w7blqq";

  # TODO: enable after https://github.com/pulumi/kubespy/issues/72 is addressed.
  # postInstall = ''
  # 	for shell in bash zsh; do
  # 		$out/bin/kubespy completion $shell > kubespy.$shell
  # 		installShellCompletion kubespy.$shell
  # 	done
  # '';

  meta = with lib; {
    description = "A tool to observe Kubernetes resources in real time";
    homepage = "https://github.com/pulumi/kubespy";
    license = licenses.asl20;
    maintainers = with maintainers; [ blaggacao ];
    platforms = platforms.unix;
  };
}
