{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kbst";
<<<<<<< HEAD
  version = "0.2.1";
=======
  version = "0.1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub{
    owner = "kbst";
    repo = "kbst";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tbSYNJp/gzEz+wEAe3bvIiZL5axZvW+bxqTOBkYSpMY=";
  };

  vendorHash = "sha256-+FY6KGX606CfTVKM1HeHxCm9PkaqfnT5XeOEXUX3Q5I=";

=======
    sha256 = "0cz327fl6cqj9rdi8zw6xrazzigjymhn1hsbjr9xxvfvfnn67xz2";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ldflags =
    let package_url = "github.com/kbst/kbst"; in
    [
      "-s" "-w"
      "-X ${package_url}.version=${version}"
      "-X ${package_url}.buildDate=unknown"
      "-X ${package_url}.gitCommit=${src.rev}"
      "-X ${package_url}.gitTag=v${version}"
      "-X ${package_url}.gitTreeState=clean"
    ];

<<<<<<< HEAD
=======
  vendorSha256 = "sha256-DZ47Bj8aFfBnxU9+e1jZiTMF75rCJtcj4yUfZRJWCic=";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  doPostInstallCheck = true;
  PostInstallCheckPhase = ''
    $out/bin/kbst help | grep v${version} > /dev/null
  '';

  meta = with lib; {
    description = "Kubestack framework CLI";
    homepage = "https://www.kubestack.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mtrsk ];
  };
}
