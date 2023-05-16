{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "k0sctl";
<<<<<<< HEAD
  version = "0.15.5";
=======
  version = "0.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ntjrk2OEIkAmNpf9Ag6HkSIOSA3NtO9hSJOBgvne4b0=";
  };

  vendorHash = "sha256-JlaXQqDO/b1xe9NA2JtuB1DZZlphWu3Mo/Mf4lhmKNo=";
=======
    sha256 = "sha256-i/XgEPuYNxn10eOXfF+X33oLlkO9r6daeygZcSdcicQ=";
  };

  vendorSha256 = "sha256-RTC2AEDzSafvJT/vuPjzs25PhuzBiPb32an/a/wpY04=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k0sproject/k0sctl/version.Environment=production"
<<<<<<< HEAD
    "-X github.com/carlmjohnson/versioninfo.Version=${version}"
    "-X github.com/carlmjohnson/versioninfo.Revision=${version}"
=======
    "-X github.com/k0sproject/k0sctl/version.Version=${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd ${pname} \
        --$shell <($out/bin/${pname} completion --shell $shell)
    done
  '';

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ nickcao qjoly ];
=======
    maintainers = with maintainers; [ nickcao ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
