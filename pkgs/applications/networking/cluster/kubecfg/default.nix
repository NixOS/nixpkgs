{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubecfg";
<<<<<<< HEAD
  version = "0.33.0";
=======
  version = "0.29.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-a/2qKiqn9en67uJD/jzU3G1k6gT73DTzjY32mi51xSQ=";
  };

  vendorHash = "sha256-mSYc12pjx34PhMx7jbKD/nPhPaK7jINmUSWxomikx7U=";
=======
    hash = "sha256-toB0rRkqRTjf51g+BcMZiHjlG/slMyzA5OfO4DbTCH8=";
  };

  vendorHash = "sha256-sntlF8VCOtIB6kFJZaDs2Uu8zWZwMLcnHWuZy2D30Zg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd kubecfg \
      --bash <($out/bin/kubecfg completion --shell=bash) \
      --zsh  <($out/bin/kubecfg completion --shell=zsh)
  '';

  meta = with lib; {
    description = "A tool for managing Kubernetes resources as code";
    homepage = "https://github.com/kubecfg/kubecfg";
    changelog = "https://github.com/kubecfg/kubecfg/releases/tag/v${version}";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ benley qjoly ];
=======
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
