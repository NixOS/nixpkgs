{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec{
  pname = "pinniped";
<<<<<<< HEAD
  version = "0.25.0";
=======
  version = "0.23.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-tUdPeBqAXYaBB2rtkhrhN3kRSVv8dg0UI7GEmIdO+fc=";
=======
    sha256 = "sha256-noWNklLRYW0l7fGBnsTQk8v5t+mwKheh0egHxL+YxAE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = "cmd/pinniped";

<<<<<<< HEAD
  vendorHash = "sha256-IFVXNd1UkfZiw8YKG3v9uHCJQCE3ajOsjbHv5r3y3L4=";
=======
  vendorHash = "sha256-P28L+IHZ+To08Y4gdv/VldAoVcMnCPlZDxy7xe5OP8o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pinniped \
      --bash <($out/bin/pinniped completion bash) \
      --fish <($out/bin/pinniped completion fish) \
      --zsh <($out/bin/pinniped completion zsh)
  '';

  meta = with lib; {
    description = "Tool to securely log in to your Kubernetes clusters";
    homepage = "https://pinniped.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bpaulin ];
  };
}
