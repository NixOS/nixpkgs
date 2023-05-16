{ lib, buildGoModule, fetchFromGitHub, installShellFiles, stdenv, testers, ocm }:

buildGoModule rec {
  pname = "ocm";
<<<<<<< HEAD
  version = "0.1.67";
=======
  version = "0.1.66";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "openshift-online";
    repo = "ocm-cli";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-MNagqeT6Uw9fLl6gJ+2FYTRZ2rO2qTYi8SBDoOR9EUM=";
  };

  vendorHash = "sha256-4d8IGe/gTt4HAqyg05pYtAFfHp6NCmUBtfxRA64rEmM=";
=======
    sha256 = "sha256-iOgDWqP9sFd5/0e5/+WP6R3PpJa8AiUE4EjI39HwWX8=";
  };

  vendorHash = "sha256-yY/X0LVIH1ULegx8MIZyUxD1wPNxxISSCBxj9aY2wtA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Strip the final binary.
  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  # Tests expect the binary to be located in the root directory.
  preCheck = ''
    ln -s $GOPATH/bin/ocm ocm
  '';

  # Tests fail in Darwin sandbox.
  doCheck = !stdenv.isDarwin;

  postInstall = ''
    installShellCompletion --cmd ocm \
      --bash <($out/bin/ocm completion bash) \
      --fish <($out/bin/ocm completion fish) \
      --zsh <($out/bin/ocm completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = ocm;
    command = "ocm version";
  };

  meta = with lib; {
    description = "CLI for the Red Hat OpenShift Cluster Manager";
    license = licenses.asl20;
    homepage = "https://github.com/openshift-online/ocm-cli";
    maintainers = with maintainers; [ stehessel ];
    platforms = platforms.all;
  };
}
