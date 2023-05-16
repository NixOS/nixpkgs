{ lib, buildGoModule, installShellFiles, fetchFromGitHub }:

buildGoModule rec {
  pname = "gum";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qPo7PmxNCEjrGWNZ/CBpGrbjevbcmnDGy/C1F1TT9zA=";
  };

  vendorHash = "sha256-47rrSj2bI8oe62CSlxrSBsEPM4I6ybDKzrctTB2MFB0=";
=======
    sha256 = "sha256-SP8n9PGfn4Oe+3+i7gT4i2WKgO35igPu+86SGp65R7g=";
  };

  vendorSha256 = "sha256-gA545IqG3us0mmWxbw3fu3mFLqJzluH/T6d3ilfnLyM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  postInstall = ''
    $out/bin/gum man > gum.1
    installManPage gum.1
    installShellCompletion --cmd gum \
      --bash <($out/bin/gum completion bash) \
      --fish <($out/bin/gum completion fish) \
      --zsh <($out/bin/gum completion zsh)
  '';

  meta = with lib; {
    description = "Tasty Bubble Gum for your shell";
    homepage = "https://github.com/charmbracelet/gum";
    changelog = "https://github.com/charmbracelet/gum/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani ];
<<<<<<< HEAD
    mainProgram = "gum";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
