{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-errorlint";
  version = "1.9.1";

  src = fetchFromCodeberg {
    owner = "polyfloyd";
    repo = "go-errorlint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QqPyb5APhrEjI4VGQ4VYmkcKE56H33f+m3A01lnURvo=";
  };

  vendorHash = "sha256-/MuY4Dsr2SMYdXHcQf08uPviu3S4VDDiIPjWiD71ZIM=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Source code linter that can be used to find code that will cause problems with Go's error wrapping scheme";
    homepage = "https://codeberg.org/polyfloyd/go-errorlint";
    changelog = "https://codeberg.org/polyfloyd/go-errorlint/src/tag/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      meain
      polyfloyd
    ];
    mainProgram = "go-errorlint";
  };
})
