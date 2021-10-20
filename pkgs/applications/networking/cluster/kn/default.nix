{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kn";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "knative";
    repo = "client";
    rev = "v${version}";
    sha256 = "sha256-hquxv1BluR535WvMtJlVyP7JuARDNGDjPAbdSSj2juo=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/kn" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X knative.dev/client/pkg/kn/commands/version.Version=v${version}"
    "-X knative.dev/client/pkg/kn/commands/version.VersionEventing=v${version}"
    "-X knative.dev/client/pkg/kn/commands/version.VersionServing=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd kn \
      --bash <($out/bin/kn completion bash) \
      --zsh <($out/bin/kn completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kn version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "The Knative client kn is your door to the Knative world. It allows you to create Knative resources interactively from the command line or from within scripts";
    homepage = "https://github.com/knative/client";
    changelog = "https://github.com/knative/client/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
