{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "fake-gcs-server";
  version = "1.56.1";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "fake-gcs-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jCQHVp+N9Hazz+ceuajCF1rRvxXkneL900pHLHOzzwA=";
  };

  vendorHash = "sha256-huKQv51wDVhagX86j3qbe9c3NHwAJX/izMIkFqXP41Y=";

  # Unit tests fail to start the emulator server in some environments (e.g. Hydra) for some reason.
  #
  # Disabling to avoid flakiness.
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Google Cloud Storage emulator & testing library";
    homepage = "https://github.com/fsouza/fake-gcs-server";
    license = lib.licenses.bsd2;
    mainProgram = "fake-gcs-server";
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
})
