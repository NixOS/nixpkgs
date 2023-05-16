{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "civo";
<<<<<<< HEAD
  version = "1.0.65";
=======
  version = "1.0.53";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "civo";
    repo   = "cli";
    rev    = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-zuWKU2bZM0zdEupvWi1CV3S7urEhm4dc+sFYoQmljCk=";
  };

  vendorHash = "sha256-Tym9Xu+oECUm78nIAyDwYYpR88wNxT4bmoy7iUwUQTU=";
=======
    sha256 = "sha256-UE83fnP2cJuRWwyAkZhaF9N64q2Cw4oR/TTnvPbDSxc=";
  };

  vendorHash = "sha256-c6Bx/+zyhvV9B1nZ7dJdIsNRSoWeHc2eE81V7Mbkwds=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;

  # Some lint checks fail
  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/civo/cli/common.VersionCli=${version}"
    "-X github.com/civo/cli/common.CommitCli=${src.rev}"
    "-X github.com/civo/cli/common.DateCli=unknown"
  ];

  doInstallCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/civo
    installShellCompletion --cmd civo \
      --bash <($out/bin/civo completion bash) \
      --fish <($out/bin/civo completion fish) \
      --zsh <($out/bin/civo completion zsh)
  '';

  meta = with lib; {
    description = "CLI for interacting with Civo resources";
    homepage = "https://github.com/civo/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ berryp ];
  };
}
