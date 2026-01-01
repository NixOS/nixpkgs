{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "rootlesskit";
<<<<<<< HEAD
  version = "2.3.6";
=======
  version = "2.3.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Y4ZuHddLisLjiftqprDdORDwM9/lSyrinWsMYtUzmco=";
  };

  vendorHash = "sha256-sEKneHvQjVBido+Z5k1XjW7qWuqGOZQQX9BMX4DGb6M=";
=======
    hash = "sha256-hidQMZMPwnOKpMYV2UL0MkYBdvQUD6SsS7ZXt6bDzI8=";
  };

  vendorHash = "sha256-sqmAOEapft5DLHWKwwuuzWY1RCzaKed8M1usyCjmKG8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    updateScript = nix-update-script { };
    tests = nixosTests.docker-rootless;
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ offline ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
