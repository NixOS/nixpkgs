{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "rootlesskit";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sHprAkdonIvtHxC4O07JMbQ3t/PtcfBiNhUmfxc2iCk=";
  };

  vendorHash = "sha256-7Tw0vukx+xxfxuANg/TmKhR5wBQhl79dVc1lKvXbi10=";

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
