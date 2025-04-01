{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "scotty";
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~phw";
    repo = "scotty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R9MgX5Am//9ULNKWqfH/JthMhqg4FFitOds7wU5iDSU=";
  };

  vendorHash = "sha256-wlyoN6y/Bh8f21d5bIzwRwWkGlXbFFx+uGK6c5PyKTs=";

  env = {
    # *Some* locale is required to be set
    # https://git.sr.ht/~phw/scotty/tree/04eddfda33cc6f0b87dc0fcea43d5c4f50923ddc/item/internal/i18n/i18n.go#L30
    LC_ALL = "C.UTF-8";
  };

  passthru = {
    tests.version = testers.testVersion {
      # See above
      command = "LC_ALL='C.UTF-8' scotty --version";
      package = finalAttrs.finalPackage;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Transfers your listens between various music listen tracking and streaming services.";
    homepage = "https://git.sr.ht/~phw/scotty";
    changelog = "https://git.sr.ht/~phw/scotty/refs/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "scotty";
  };
})
