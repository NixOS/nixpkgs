{ lib, buildGoModule, fetchFromGitHub, installShellFiles, stdenv, testers, ocm }:

buildGoModule rec {
  pname = "ocm";
  version = "0.1.67";

  src = fetchFromGitHub {
    owner = "openshift-online";
    repo = "ocm-cli";
    rev = "v${version}";
    sha256 = "sha256-MNagqeT6Uw9fLl6gJ+2FYTRZ2rO2qTYi8SBDoOR9EUM=";
  };

  vendorHash = "sha256-4d8IGe/gTt4HAqyg05pYtAFfHp6NCmUBtfxRA64rEmM=";

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
