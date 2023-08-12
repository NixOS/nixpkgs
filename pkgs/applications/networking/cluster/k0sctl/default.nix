{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sMMYuE/KIWScZTCuzW9WQpCDHI+Og1zRxGlZzOuHgNo=";
  };

  vendorSha256 = "sha256-6UWRh0NHFr7adJJSmrfTjzXH75Dmjed/+KxH6Kz//jk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k0sproject/k0sctl/version.Environment=production"
    "-X github.com/carlmjohnson/versioninfo.Version=${version}"
    "-X github.com/carlmjohnson/versioninfo.Revision=${version}"
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
    maintainers = with maintainers; [ nickcao qjoly ];
  };
}
