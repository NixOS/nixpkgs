{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kfilt";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.0.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ryane";
    repo = "kfilt";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2lPYrztj2SFnfQ10Y6xKtWq2wekqYT5lF4VPLjS1pXs=";
  };

  vendorHash = "sha256-TR6DZ8jV2InNT0IkFurESWT+2F4NDy2lRYhAMy0/h5c=";
=======
    hash = "sha256-TUhZKf4fJyJF/qDmvs4jqAMVTXN4MXE+YLc4FcOVlwo=";
  };

  vendorHash = "sha256-c77CzpE9cPyobt87uO0QlkKD+xC/tM7wOy4orM62tnI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ryane/kfilt/cmd.Version=${version}"
    "-X github.com/ryane/kfilt/cmd.GitCommit=${src.rev}"
  ];

  meta = {
    description = "Command-line tool that filters Kubernetes resources";
    mainProgram = "kfilt";
    homepage = "https://github.com/ryane/kfilt";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ryane ];
  };
}
