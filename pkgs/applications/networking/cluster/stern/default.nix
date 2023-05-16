{ stdenv, lib, buildPackages, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "stern";
<<<<<<< HEAD
  version = "1.26.0";
=======
  version = "1.25.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-86XoYzw1bnIWwGiFgRl9RcZSYrF4byYKnDlJ4QSqXV0=";
  };

  vendorHash = "sha256-LLVd9WB8ixH78CHYe0sS4sCDCD+6SQ7PxWr2MHiAOxI=";
=======
    sha256 = "sha256-E4Hs9FH+6iQ7kv6CmYUHw9HchtJghMq9tnERO2rpL1g=";
  };

  vendorHash = "sha256-+B3cAuV+HllmB1NaPeZitNpX9udWuCKfDFv+mOVHw2Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X github.com/stern/stern/cmd.version=${version}" ];

  postInstall = let
    stern = if stdenv.buildPlatform.canExecute stdenv.hostPlatform then "$out" else buildPackages.stern;
  in
    ''
      for shell in bash zsh; do
        ${stern}/bin/stern --completion $shell > stern.$shell
        installShellCompletion stern.$shell
      done
    '';

  meta = with lib; {
    description = "Multi pod and container log tailing for Kubernetes";
    homepage = "https://github.com/stern/stern";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbode preisschild ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
