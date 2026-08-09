{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "rootlesskit";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kqEXut8z5AQsJM6f+paXmqbWao/knQFgLlrghzQHvds=";
  };

  vendorHash = "sha256-IQ+sgqmyAuInIcSNsFisRqjr+9wKobi5+zk/C0aPbKI=";

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
