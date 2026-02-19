{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "fake-gcs-server";
  version = "1.54.0";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "fake-gcs-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mskNNTytnqqFXP4REMz7KLgWL0ma/8hlQKSAABOGuvk=";
  };

  vendorHash = "sha256-KNappojVBU1F9F3FqindXVDzOIy7IwYd7xVzbqQk6QE=";

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
