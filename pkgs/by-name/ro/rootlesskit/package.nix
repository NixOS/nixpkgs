{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "rootlesskit";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    hash = "sha256-Y4ZuHddLisLjiftqprDdORDwM9/lSyrinWsMYtUzmco=";
  };

  vendorHash = "sha256-sEKneHvQjVBido+Z5k1XjW7qWuqGOZQQX9BMX4DGb6M=";

  passthru = {
    updateScript = nix-update-script { };
    tests = nixosTests.docker-rootless;
  };

  meta = {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ offline ];
    platforms = lib.platforms.linux;
  };
}
