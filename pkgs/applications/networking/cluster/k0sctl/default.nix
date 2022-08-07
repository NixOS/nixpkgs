{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1SlVGQLU/7UmcvyKD/BaJSBCdOWACteQtR2Os4THPaU=";
  };

  vendorSha256 = "sha256-vTcFJ7L8FW0IZBNarje/Oc3+jSRMga8+/nPLvqus2vY=";

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
