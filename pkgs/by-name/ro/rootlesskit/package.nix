{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "rootlesskit";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-q1I2Jm5H5ucp4e8fHgDlI2dDRPWvqhgcgsTUKyEPPD4=";
  };

  vendorHash = "sha256-AnAiKR0STVRW+WzjhFJ9bhZ2ISpKpKOLDBiiz/uczhs=";

  passthru = {
    updateScript = nix-update-script { };
    tests = nixosTests.docker-rootless;
  };

  meta = {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
