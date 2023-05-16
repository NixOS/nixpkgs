{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

let
  pname = "lefthook";
<<<<<<< HEAD
  version = "1.4.8";
=======
  version = "1.3.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildGoModule rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "evilmartians";
    repo = "lefthook";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lK2JGENCqfNXXzZBHirEoOB5+ktea38ypb2VD7GWxhg=";
  };

  vendorHash = "sha256-/VLS7+nPERjIU7V2CzqXH69Z3/y+GKZbAFn+KcRKRuA=";
=======
    hash = "sha256-zEY8iFF3SyZrIWveUWW3dvWnZL4h7rQ8EcMNIcWJ5g8=";
  };

  vendorHash = "sha256-UMT39If9Oa7vgpkW2oltCUkaNQ0Qf1nCO5Z8F8SaajA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd lefthook \
      --bash <($out/bin/lefthook completion bash) \
      --fish <($out/bin/lefthook completion fish) \
      --zsh <($out/bin/lefthook completion zsh)
  '';

  meta = {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/evilmartians/lefthook";
    changelog = "https://github.com/evilmartians/lefthook/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
<<<<<<< HEAD
    mainProgram = "lefthook";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
