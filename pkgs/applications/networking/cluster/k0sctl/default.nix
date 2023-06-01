{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i/XgEPuYNxn10eOXfF+X33oLlkO9r6daeygZcSdcicQ=";
  };

  vendorSha256 = "sha256-RTC2AEDzSafvJT/vuPjzs25PhuzBiPb32an/a/wpY04=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k0sproject/k0sctl/version.Environment=production"
    "-X github.com/k0sproject/k0sctl/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd ${pname} \
        --$shell <($out/bin/${pname} completion --shell $shell)
    done
  '';

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
