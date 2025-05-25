{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "rootlesskit";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    hash = "sha256-hidQMZMPwnOKpMYV2UL0MkYBdvQUD6SsS7ZXt6bDzI8=";
  };

  vendorHash = "sha256-sqmAOEapft5DLHWKwwuuzWY1RCzaKed8M1usyCjmKG8=";

  passthru = {
    updateScript = nix-update-script { };
    tests = nixosTests.docker-rootless;
  };

  meta = with lib; {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
