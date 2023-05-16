{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "imgcrypt";
<<<<<<< HEAD
  version = "1.1.8";
=======
  version = "1.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "containerd";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FLqFzEEfgsKcjAevhF6+8mR3zOUjfXyfWwWsxVOcdJU=";
  };

  vendorHash = null;

=======
    sha256 = "sha256-VGP63tGyYD/AtjEZD1uo8A2I/4Di7bfLeeaNat+coI4=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ldflags = [
    "-X github.com/containerd/containerd/version.Version=${version}"
  ];

<<<<<<< HEAD
=======
  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  subPackages = [ "cmd/ctd-decoder" "cmd/ctr" ];

  postFixup = ''
    mv $out/bin/ctr $out/bin/ctr-enc
  '';

  meta = with lib; {
    description = "Image encryption library and command line tool";
    homepage = "https://github.com/containerd/imgcrypt";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mikroskeem ];
  };
}
