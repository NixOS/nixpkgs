{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "fake-gcs-server";
  version = "1.55.0";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "fake-gcs-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XbwiPWhudTUhiCA91n8av7oQ0USPA/vXHePfS7/jnOg=";
  };

  vendorHash = "sha256-9zovcKQ3eiYWHCxUBXI39kgnjD4mR/4GGAZz65f7Of4=";

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
