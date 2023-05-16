{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-view-secret";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-IdbJQ3YCIPcp09/NORWGezqjbwktObN7TuQdq5uAN4A=";
  };

  vendorHash = "sha256-Q6OosaHDzq9a2Nt18LGiGJ1C2i1/BRYGaNEBeK0Ohiw=";
=======
    sha256 = "sha256-+0uHBzT8cocuDttkvNHnmy/WQ+mfVIc0J0fkhBf4PLI=";
  };

  vendorSha256 = "sha256-A3bB4L4O7j6lnP3c4mF4zVY/fDac6OBM5uKJuCnZR9g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "./cmd/" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-view-secret
  '';

  meta = with lib; {
    description = "Kubernetes CLI plugin to decode Kubernetes secrets";
    homepage = "https://github.com/elsesiy/kubectl-view-secret";
    changelog = "https://github.com/elsesiy/kubectl-view-secret/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.sagikazarmark ];
  };
}
