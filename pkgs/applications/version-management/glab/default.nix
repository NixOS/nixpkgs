{ lib, buildGoModule, fetchFromGitLab, installShellFiles, stdenv }:

buildGoModule rec {
  pname = "glab";
<<<<<<< HEAD
  version = "1.32.0";
=======
  version = "1.28.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7XFekLlWcifqGJL6IIONpixdMAyGBJJmqo+l6RKCfC8=";
  };

  vendorHash = "sha256-HiU6Kx/du8QLNKUDsSMm349msxSxyNRppxadtIpglBg=";
=======
    hash = "sha256-e3tblY/lf25TJrsLeQdaPcgVlsaEimkjQxO0P9X1o6w=";
  };

  vendorHash = "sha256-PH0PJujdRtnVS0s6wWtS6kffQBQduqb2KJYru9ePatw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    # failed to read configuration:  mkdir /homeless-shelter: permission denied
    export HOME=$TMPDIR
  '';

  subPackages = [ "cmd/glab" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
<<<<<<< HEAD
    make manpage
    installManPage share/man/man1/*
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    installShellCompletion --cmd glab \
      --bash <($out/bin/glab completion -s bash) \
      --fish <($out/bin/glab completion -s fish) \
      --zsh <($out/bin/glab completion -s zsh)
  '';

  meta = with lib; {
    description = "GitLab CLI tool bringing GitLab to your command line";
    license = licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
<<<<<<< HEAD
    changelog = "https://gitlab.com/gitlab-org/cli/-/releases/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ freezeboy ];
  };
}
