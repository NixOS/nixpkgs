{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krelay";
<<<<<<< HEAD
  version = "0.0.6";
=======
  version = "0.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "knight42";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-hyjseBIyPdY/xy163bGtfNR1rN/cQczJO53gu4/WmiU=";
  };

  vendorHash = "sha256-uDLc1W3jw3F+23C5S65Tcljiurobw4IRw7gYzZyBxQ0=";
=======
    sha256 = "sha256-NAIRzHWXD4z6lpwi+nVVoCIzfWdaMdrWwht24KgQh3c=";
  };

  vendorSha256 = "sha256-1/zy5gz1wvinwzRjjhvrIHdjO/Jy/ragqM5QQaAajXI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/client" ];

  ldflags = [ "-s" "-w" "-X github.com/knight42/krelay/pkg/constants.ClientVersion=${version}" ];

  postInstall = ''
    mv $out/bin/client $out/bin/kubectl-relay
  '';

  meta = with lib; {
    description = "A better alternative to `kubectl port-forward` that can forward TCP or UDP traffic to IP/Host which is accessible inside the cluster.";
    homepage = "https://github.com/knight42/krelay";
    changelog = "https://github.com/knight42/krelay/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky ];
    mainProgram = "kubectl-relay";
  };
}
