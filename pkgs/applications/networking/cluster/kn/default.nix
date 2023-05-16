{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kn";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "knative";
    repo = "client";
    rev = "knative-v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Aiu8SedWCP2yIw51+aVEFcskJKee8RvUcW6yGtagSnI=";
=======
    sha256 = "sha256-LkjE3GMHoD+PmB4J09xf71nBrY1KPvh13l2O3QN9EH0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

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
