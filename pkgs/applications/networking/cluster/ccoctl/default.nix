{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule {
  pname = "ccoctl";
  version = "4.13.0";

  # When updating, pin `rev` to latest commit in the `4.x` release branch.
  src = fetchFromGitHub {
    owner = "openshift";
    repo = "cloud-credential-operator";
    rev = "0621fcaf818f57ab05602259c1eb14db07b68dce";
    hash = "sha256-zWOIRfltCOvkYpk9flvS7pBtfeLhBGwAJNe6WfrEd9c=";
  };

  # Dependencies are vendored in the repository.
  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/ccoctl" ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installShellCompletion --cmd ccoctl \
      --bash <($out/bin/ccoctl completion bash) \
      --fish <($out/bin/ccoctl completion fish) \
      --zsh <($out/bin/ccoctl completion zsh)
  '';

  meta = with lib; {
    description = "Manage cloud provider credentials as Kubernetes CRDs";
    homepage = "https://github.com/openshift/cloud-credential-operator";
    license = licenses.asl20;
    maintainers = with maintainers; [ stehessel ];
  };
}
