{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubespy";
  version = "0.6.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "pulumi";
    repo = "kubespy";
    sha256 = "1xrwhxw2y0zpzsxp1rlm1wd0aqw6jda5ai5y1ards5djqsbsv87g";
  };

  vendorSha256 = "0ajhbjs9ijpxp3svvj7pjiac78ps7vkqmqrizq18mllsry0m9pcl";

  doCheck = false;

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
