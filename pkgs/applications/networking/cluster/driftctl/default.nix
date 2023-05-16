{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "driftctl";
<<<<<<< HEAD
  version = "0.39.0";
=======
  version = "0.38.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "driftctl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-1i5x05q0Mo3E3ExM9qONRtQCH3nO7pXyNqOaAtz7qYE=";
  };

  vendorHash = "sha256-H/+LORl7Bjy1NshjtWDzj13YCrlQQgtBr4+Rz/rxQkY=";
=======
    sha256 = "sha256-PPzoZypTP3yrgU50Uv7yBNCc2nAa84quCTWjxyq9h/c=";
  };

  vendorHash = "sha256-XVEXWBVqYoAlK4DP0GdWqJDcLy9WxCaUdNbVESJ9zoM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/snyk/driftctl/pkg/version.version=v${version}"
    "-X github.com/snyk/driftctl/build.env=release"
    "-X github.com/snyk/driftctl/build.enableUsageReporting=false"
  ];

  postInstall = ''
    installShellCompletion --cmd driftctl \
      --bash <($out/bin/driftctl completion bash) \
      --fish <($out/bin/driftctl completion fish) \
      --zsh <($out/bin/driftctl completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/driftctl --help
    $out/bin/driftctl version | grep "v${version}"
    # check there's no telemetry flag
    $out/bin/driftctl --help | grep -vz "telemetry"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://driftctl.com/";
    changelog = "https://github.com/snyk/driftctl/releases/tag/v${version}";
    description = "Detect, track and alert on infrastructure drift";
    longDescription = ''
      driftctl is a free and open-source CLI that warns of infrastructure drift
      and fills in the missing piece in your DevSecOps toolbox.
    '';
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ kaction jk qjoly ];
=======
    maintainers = with maintainers; [ kaction jk ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
