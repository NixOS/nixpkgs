{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "fake-gcs-server";
  version = "1.53.1";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "fake-gcs-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UNXmbfCmLfY3gvstR2sEQ5SmHJy7PBe38JMCnc2GTz8=";
  };

  vendorHash = "sha256-+X0/vHHfzz4u7taeUhrH3E3TCZ2ABYwurDwg0THfnKY=";

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
